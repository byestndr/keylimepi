import 'package:chopper/chopper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:key_limepi/backend/spotify/spotify_api.dart';

part 'album_provider.g.dart';

@Riverpod(keepAlive: true)
class AlbumProvider extends _$AlbumProvider {
  final SpotifyUserService _spotifyAPI = SpotifyUserService.create();

  @override
  Future<List<dynamic>> build() {
    return getAlbums();
  }

  Future<List<dynamic>> getAlbums() async {
    final Response<dynamic> spotifyResponse = await _spotifyAPI.getAlbums();
    final List<dynamic> albums = spotifyResponse.body['items'];
    return albums;
  }
}
