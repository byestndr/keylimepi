import 'dart:convert';

import 'package:chopper/src/response.dart';
import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spotimmich/backend/lyric/lyric_api.dart';
import 'package:spotimmich/providers/spotify/likedSongs_provider.dart';
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

    final List<LyricLine> lyricsList = LyricLine.fromSyncedLyrics(
      lyrics.body['syncedLyrics'].toString(),
    );

    ref.invalidate(currentLyricProvider);

    return lyricsList;
  }
}

@riverpod
class CurrentLyric extends _$CurrentLyric {
  @override
  Future<LyricLine> build() async {
    return _getCurrentLine();
  }

  Future<LyricLine> _getCurrentLine() async {
    final List<LyricLine> lyricList = await ref.read(
      lyricsGetterProvider.future,
    );

    if (lyricList.isEmpty) return LyricLine(line: '', timestamp: Duration());

    final double currentPosition = ref.read(seekbarPositionProvider);
    final int index = lowerBound(
      lyricList,
      LyricLine(
        line: '',
        timestamp: Duration(milliseconds: currentPosition.toInt()),
      ),
      compare: (LyricLine lyric, LyricLine position) {
        
        return lyric.timestamp.compareTo(position.timestamp);
      },
    );

    return LyricLine(line: 'dsa', timestamp: Duration());
  }
}
