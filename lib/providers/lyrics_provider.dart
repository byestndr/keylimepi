import 'dart:convert';

import 'package:chopper/src/response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spotimmich/backend/lyric/lyric_api.dart';
import 'package:spotimmich/providers/spotify/likedSongs_provider.dart';
import 'package:spotimmich/providers/spotify/song_info_provider.dart';

part 'lyrics_provider.g.dart';

// TODO: Get this to stop refreshing if the state is the same
@Riverpod(keepAlive: true)
class LyricsGetter extends _$LyricsGetter {
  @override
  Future<Map<String, dynamic>> build() async {
    final Song currentSong = await ref.watch(infoGetterProvider.future);
    return getNewLyrics(currentSong);
  }

  Future<Map<String, dynamic>> getNewLyrics(final Song currentSong) async {
    final LyricService lyricService = LyricService.create();
    final Response<dynamic> lyrics = await lyricService.getLyrics(
      trackName: currentSong.title,
      artistName: currentSong.artist,
      albumName: currentSong.album.toString(),
    );

    return lyrics.body;
  }
}
