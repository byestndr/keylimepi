import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spotimmich/backend/spotify/spotify_api-chopper.dart';
import 'package:spotimmich/backend/spotify/spotifyapi.dart';

part 'playlists_provider.g.dart';

@Riverpod(keepAlive: true)
class PlaylistsProvider extends _$PlaylistsProvider {
  final SpotifyUserService _spotifyAPI = SpotifyUserService.create();

  @override
  Future<List<dynamic>> build() {
    return getPlaylists();
  }

  Future<List<dynamic>> getPlaylists() async {
    final Response<dynamic> spotifyResponse = await _spotifyAPI.getPlaylists();
    final List<dynamic> playlists = spotifyResponse.body['items'];
    return playlists;
  }

  Future<void> startPlaylist(int playlistIndex) async {
    final List<dynamic>? playlists = state.value; 

    final String playlistID = playlists![playlistIndex]['uri'];
    await Interactions().resumePlayback(context_uri: playlistID);
  }
}
