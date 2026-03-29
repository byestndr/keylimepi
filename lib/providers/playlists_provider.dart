import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spotimmich/backend/spotify/spotifyapi.dart';

part 'playlists_provider.g.dart';

@riverpod
class PlaylistsProvider extends _$PlaylistsProvider{
  @override
  Future<List<dynamic>> build() {
    return getPlaylists();
  }

  Future<List<dynamic>> getPlaylists() async {
    final dynamic response = await Interactions().getCachedPlaylists();
    final Map<dynamic, dynamic> body = jsonDecode(response);
    final List<dynamic> playlists = body['items'];
    return playlists;
  }

  Future<void> refreshPlaylists() async {
    await Interactions().getUserPlaylists();
    ref.invalidateSelf();
    return;
  }

  Future<void> startPlaylist(int playlistIndex) async {
    final List<dynamic> playlists = await getPlaylists();
    final String playlistID = playlists[playlistIndex]['uri'];
    await Interactions().resumePlayback(context_uri: playlistID);
  }
}

