import 'package:chopper/src/response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spotimmich/backend/spotify/spotify_api.dart';
import 'package:spotimmich/providers/spotify/song_info_provider.dart';

part 'spotify_playbackstate.g.dart';

@Riverpod(keepAlive: true)
class SpotifyPlaybackState extends _$SpotifyPlaybackState {
  @override
  Future<Response> build() async {
    ref.watch(refreshTimerProvider);

    return getNewPlaybackState();
  }

  Future<Response> getNewPlaybackState() async {
    final SpotifyUserService spotifyAPI = SpotifyUserService.create();
    final Response<dynamic> spotifyResponse = await spotifyAPI.getPlayerState();

    return spotifyResponse;
  }
}

@Riverpod(keepAlive: true)
class SpotifyAuthenticated extends _$SpotifyAuthenticated {
  @override
  bool build() {
    return false;
  }

  void setTrue() {
    state = true;
    return;
  }

  void setFalse() {
    state = false;
    return;
  }
}
