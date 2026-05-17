import 'dart:convert';

import 'package:chopper/src/response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:romanize/romanize.dart';
import 'package:spotimmich/backend/lyric/lyric_api.dart';
import 'package:spotimmich/providers/settings_provider.dart';
import 'package:spotimmich/providers/spotify/seekbar_provider.dart';
import 'package:spotimmich/providers/spotify/song_info_provider.dart';

part 'lyrics_provider.g.dart';

class LyricLine {
  Duration timestamp;
  String line;
  LyricLine({required this.line, required this.timestamp});

  static List<LyricLine> fromSyncedLyrics(String lyrics) {
    final List<String> splitLyrics = const LineSplitter().convert(lyrics);
    List<LyricLine> lyricsList = <LyricLine>[];
    for (final String line in splitLyrics) {
      final RegExp regEx = RegExp(r'\[(\d+):(\d{2}(?:\.\d+)?)\]');
      final String? unprocesssedTimestamp = regEx.stringMatch(line);

      if (unprocesssedTimestamp == null) {
        continue;
      }

      final String bracketlessTimestamp = unprocesssedTimestamp.replaceAll(
        RegExp(r'\[|\]'),
        '',
      );
      final List<String> splitTimestamp = bracketlessTimestamp.split(':');
      final int timestampMinute = int.parse(splitTimestamp[0]);

      final List<String> splitSeconds = splitTimestamp[1].split('.');
      final int timestampSeconds = int.parse(splitSeconds[0]);
      final int timestampMiliseconds = int.parse(splitSeconds[1]);

      final Duration timestamp = Duration(
        minutes: timestampMinute,
        seconds: timestampSeconds,
        milliseconds: timestampMiliseconds,
      );

      final String lyricLine = line
          .replaceAll(unprocesssedTimestamp!, '')
          .trim();

      lyricsList.add(LyricLine(line: lyricLine, timestamp: timestamp));
    }
    return lyricsList;
  }

  Future<LyricLine> romanize() async {
    if (line.isEmpty) {
      return LyricLine(line: line, timestamp: timestamp);
    }
    final Romanizer analyzedText = TextRomanizer.detectLanguage(line);

    // if (analyzedText.language != 'japanese') {
      // final String romanizedText = analyzedText.romanize(line);
      // return LyricLine(line: romanizedText, timestamp: timestamp);
    // }

    final Uri romajiURI = Uri(
      scheme: 'https',
      host: 'yomi.onrender.com',
      path: '/analyze',
    );
    final http.Response response = await http.post(
      romajiURI,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'text': line,
        'to': 'romaji',
        'romaji_system': 'hepburn',
        'mode': 'spaced',
      },
    );
    // Body is a string so some reason, so we decode twice.
    final dynamic strippedString = jsonDecode(response.body);
    final dynamic convertedBody = jsonDecode(strippedString);

    return LyricLine(line: convertedBody['converted'], timestamp: timestamp);
  }
}

@Riverpod(keepAlive: true)
class LyricsGetter extends _$LyricsGetter {
  @override
  Future<List<LyricLine>> build() async {
    return getNewLyrics();
  }

  Future<List<LyricLine>> getNewLyrics() async {
    final Song currentSong = await ref.read(infoGetterProvider.future);

    final LyricService lyricService = LyricService.create();
    final Response<dynamic> lyrics = await lyricService.getLyrics(
      trackName: currentSong.title,
      artistName: currentSong.artist,
      albumName: currentSong.album.toString(),
    );

    final dynamic responseBody = lyrics.body;

    List<LyricLine> lyricsList;
    if (responseBody == null) {
      lyricsList = [
        LyricLine(
          line: 'No synced lyrics were found',
          timestamp: const Duration(seconds: 0),
        ),
      ];
    } else {
      lyricsList = LyricLine.fromSyncedLyrics(
        lyrics.body['syncedLyrics'].toString(),
      );
    }

    final bool romanizationBool = ref.read(userSettingsProvider).isRomanized;
    if (romanizationBool) {
      for (final LyricLine line in lyricsList) {
        final LyricLine romanizedLine = await line.romanize();
        final int replacedIndex = lyricsList.indexWhere(
          (LyricLine element) => element.timestamp == line.timestamp,
        );

        lyricsList[replacedIndex] = romanizedLine;
      }
    }

    ref.invalidate(currentLyricIndexProvider);
    return lyricsList;
  }
}

@riverpod
Future<List<int>> LyricSync(Ref ref) async {
  final List<LyricLine> lyricsList = await ref.watch(
    lyricsGetterProvider.future,
  );
  final SeekbarTime songDuration = ref.read(seekbarPositionProvider);

  final int totalTimeAsIndex =
      (songDuration.maxPosition.inMilliseconds / 10).ceil() + 1;

  // Each index represents a value of 100 ms
  final List<int> indexList = List.filled(totalTimeAsIndex, 0);

  // Start at 0 ms
  int currentIndex = 0;

  // Iterate over each 100 ms
  for (int i = 0; i < totalTimeAsIndex; i++) {
    // While the current 100 ms is less in length than the total song time
    while (currentIndex + 1 < lyricsList.length &&
        lyricsList[currentIndex + 1].timestamp.inMilliseconds <= i * 10) {
      currentIndex++;
    }

    indexList[i] = currentIndex;
  }

  return indexList;
}

@riverpod
class CurrentLyricIndex extends _$CurrentLyricIndex {
  @override
  Future<int> build() async {
    final SeekbarTime currentPosition = ref.watch(seekbarPositionProvider);
    final int progressDelay = ref.watch(lyricDelayProvider);

    return _getCurrentLine(currentPosition, progressDelay);
  }

  Future<int> _getCurrentLine(SeekbarTime seekbarPosition, int delay) async {
    final List<int> lyricIndexList = await ref.read(lyricSyncProvider.future);
    final int adjustedPosition =
        seekbarPosition.currentPosition.inMilliseconds + delay;

    final int lyricIndex = lyricIndexList[(adjustedPosition / 10).floor()];

    return lyricIndex;
  }
}

@riverpod
class LyricDelay extends _$LyricDelay {
  @override
  int build() {
    return 0;
  }

  void increaseDelay(int delay) {
    state = state + delay;
    return;
  }

  void decreaseDelay(int delay) {
    state = state - delay;
    return;
  }
}
