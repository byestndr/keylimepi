import 'package:chopper/src/response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spotimmich/backend/spotify/spotify_api-chopper.dart';
import 'package:spotimmich/providers/spotify/song_info_provider.dart';

part 'spotify_playbackstate.g.dart';

@Riverpod(keepAlive: true)
class SpotifyPlaybackstate extends _$SpotifyPlaybackstate {
  @override
  Future<Map<String, dynamic>> build() async {
    ref.watch(refreshTimerProvider);

    return getNewPlaybackState();
  }

  Future<Map<String, dynamic>> getNewPlaybackState() async {
    final SpotifyUserService spotifyAPI = SpotifyUserService.create();
    final Response<dynamic> spotifyResponse = await spotifyAPI.getPlayerState();

    return spotifyResponse.body;
  }
}
