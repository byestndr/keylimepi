import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spotimmich/settings/spotify/spotifyapi.dart';

part 'likedSongs_provider.g.dart';

@riverpod
class SongProvider extends _$SongProvider {
  @override
  Future<List<dynamic>> build() {
    return getSongs();
  }

  Future<List<dynamic>> getSongs() async {
    final dynamic response = await Interactions().getCachedSongs();
    final Map<dynamic, dynamic> body = jsonDecode(response);
    final List<dynamic> songs = body['items'];
    return songs;
  }

  Future<void> refreshSongs() async {
    await Interactions().getLikedSongs();
    ref.invalidateSelf();
    return;
  }

  Future<void> startSong(songIndex) async {
    final List<dynamic> songs = await getSongs();
    final String songID = songs[songIndex]['track']['uri'];
    await Interactions().resumePlayback(context_uri: songID);
  }
}

