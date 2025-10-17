import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spotimmich/settings/spotify/spotifyapi.dart';

part 'album_provider.g.dart';

@riverpod
class AlbumProvider extends _$AlbumProvider {
  @override
  Future<List<dynamic>> build() {
    return getAlbums();
  }

  Future<List<dynamic>> getAlbums() async {
    final dynamic response = await Interactions().getCachedAlbums();
    final Map<dynamic, dynamic> body = jsonDecode(response);
    final List<dynamic> albums = body['items'];
    return albums;
  }

  Future<void> refreshAlbums() async {
    await Interactions().getSavedAlbums();
    ref.invalidateSelf();
    return;
  }

  Future<void> startAlbum(albumIndex) async {
    final List<dynamic> playlists = await getAlbums();
    final String albumID = playlists[albumIndex]['album']['uri'];
    await Interactions().resumePlayback(context_uri: albumID);
  }
}

