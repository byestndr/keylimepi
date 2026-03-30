import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spotimmich/backend/spotify/spotify_api-chopper.dart';
import 'package:spotimmich/backend/spotify/spotifyapi.dart';

part 'likedSongs_provider.g.dart';

@riverpod
class SongProvider extends _$SongProvider {
  final SpotifyUserService _spotifyAPI = SpotifyUserService.create();

  @override
  Future<List<dynamic>> build() {
    return getSongs();
  }

  Future<List<dynamic>> getSongs() async {
    final Response<dynamic> spotifyResponse = await _spotifyAPI.getLikedSongs();
    final List<dynamic> songs = spotifyResponse.body['items'];
    return songs;
  }

  Future<void> startSong(int songIndex) async {
    final List<dynamic> songs = await getSongs();
    final String songID = songs[songIndex]['track']['uri'];
    await Interactions().resumePlayback(context_uri: songID);
  }
}
