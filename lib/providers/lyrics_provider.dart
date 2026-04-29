import 'dart:convert';

import 'package:chopper/src/response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spotimmich/backend/lyric/lyric_api.dart';
import 'package:spotimmich/providers/spotify/likedSongs_provider.dart';
import 'package:spotimmich/providers/spotify/song_info_provider.dart';

part 'lyrics_provider.g.dart';

class LyricLine {
  String timestamp;
  String line;
  LyricLine({required this.line, required this.timestamp});

  static List<LyricLine> fromSyncedLyrics(String lyrics) {
    final List<String> splitLyrics = const LineSplitter().convert(lyrics);
    List<LyricLine> lyricsList = [];
    for (final String line in splitLyrics) {
      final regEx = RegExp(r'\[(\d+):(\d{2}(?:\.\d+)?)\]');

      final String? timestamp = regEx.stringMatch(line);
      final String lyricLine = line.replaceAll(timestamp!, '').trim();

      lyricsList.add(LyricLine(line: lyricLine, timestamp: timestamp));
    }
    return lyricsList;
  }
}

@Riverpod(keepAlive: true)
class LyricsGetter extends _$LyricsGetter {
  @override
  Future<Map<String, dynamic>> build() async {
    return getNewLyrics();
  }

  Future<Map<String, dynamic>> getNewLyrics() async {
    final Song currentSong = await ref.read(infoGetterProvider.future);

    final LyricService lyricService = LyricService.create();
    final Response<dynamic> lyrics = await lyricService.getLyrics(
      trackName: currentSong.title,
      artistName: currentSong.artist,
      albumName: currentSong.album.toString(),
    );

    return lyrics.body;
  }
}
