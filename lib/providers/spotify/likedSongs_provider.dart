import 'package:chopper/chopper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:key_limepi/backend/spotify/spotify_api.dart';

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
}
