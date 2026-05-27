import 'package:chopper/src/response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:key_limepi/lyrics/backend/lyric_api.dart';
import 'package:key_limepi/providers/lyrics/lyric_classes.dart';
import 'package:key_limepi/providers/settings_provider.dart';
import 'package:key_limepi/providers/spotify/seekbar_provider.dart';
import 'package:key_limepi/providers/spotify/song_info_provider.dart';

part 'lyrics_provider.g.dart';

@Riverpod(keepAlive: true)
class LyricsGetter extends _$LyricsGetter {
  @override
  Future<List<LyricLine>> build() async {
    return _getNewLyrics();
  }

  Future<List<LyricLine>> _getNewLyrics() async {
    final Song currentSong = await ref.read(infoGetterProvider.future);

    final LyricService lyricService = LyricService.create();
    final Response<dynamic> lyrics = await lyricService.getLyrics(
      trackName: currentSong.title,
      artistName: currentSong.artist,
      albumName: currentSong.album.toString(),
    );

    // Checks to see if there are any synced lyrics
    final dynamic responseBody = lyrics.body;
    List<LyricLine> lyricsList;
    if (responseBody == null || responseBody['syncedLyrics'] == null) {
      lyricsList = [
        LyricLine(
          line: 'No synced lyrics were found',
          timestamp: const Duration(seconds: 0),
        ),
      ];

      return lyricsList;
    }

    // Creates a list of lyric lines from the synced lyrics response
    lyricsList = LyricLine.fromSyncedLyrics(lyrics.body['syncedLyrics']);

    // Checks if romanization is turned on and if it isn't, returns.
    final bool romanizationBool = ref.read(userSettingsProvider).isRomanized;
    if (!romanizationBool) {
      return lyricsList;
    }

    lyricsList = await _romanizeLines(lyricsList);
    return lyricsList;
  }

  Future<List<LyricLine>> _romanizeLines(
    final List<LyricLine> lyricsList,
  ) async {
    // List of future romanization tasks to run concurrently
    // The loop adds each line as a romanization task
    List<Future<LyricLine>> romanizedFutures = [];
    for (final LyricLine line in lyricsList) {
      romanizedFutures.add(line.romanize());
    }

    final List<LyricLine> convertedLyrics = await Future.wait(romanizedFutures);

    List<LyricLine> replacedLyricList = lyricsList;
    // Replace each line with the future result
    for (final LyricLine line in convertedLyrics) {
      final int replacedIndex = lyricsList.indexWhere(
        (LyricLine element) => element.timestamp == line.timestamp,
      );

      replacedLyricList[replacedIndex] = line;
    }

    return replacedLyricList;
  }

  Future<void> overrideLyrics(String lyrics) async {
    List<LyricLine> lyricsList = LyricLine.fromSyncedLyrics(lyrics);

    final bool romanizationBool = ref.read(userSettingsProvider).isRomanized;
    if (romanizationBool) {
      lyricsList = await _romanizeLines(lyricsList);
    }

    state = AsyncValue.data(lyricsList);
    return;
  }
}

@riverpod
Future<List<int>> lyricSync(Ref ref) async {
  final List<LyricLine> lyricsList = await ref.watch(
    lyricsGetterProvider.future,
  );
  final SeekbarTime songDuration = ref.read(seekbarPositionProvider);

  final int totalTimeAsIndex =
      (songDuration.maxPosition.inMilliseconds / 10).ceil() + 1;

  // Each index represents a value of 10 ms
  final List<int> indexList = List.filled(totalTimeAsIndex, 0);

  // Start at 0 ms
  int currentIndex = 0;

  // Iterate over each 10 ms
  for (int i = 0; i < totalTimeAsIndex; i++) {
    // While the current 10 ms is less in length than the total song time
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
