import 'package:chopper/chopper.dart';
import 'dart:async';

import 'package:spotimmich/backend/spotify/spotify_authentication.dart';

part 'spotify_api-chopper.chopper.dart';

@ChopperApi(baseUrl: '/v1/me')
abstract class SpotifyUserService extends ChopperService {
  @GET(path: "/player")
  Future<Response> getPlayerState();

  @GET(path: "/playlists")
  Future<Response> getPlaylists();

  @GET(path: '/albums')
  Future<Response> getAlbums();

  @GET(path: '/tracks')
  Future<Response> getLikedSongs();

  @GET(path: '/player/queue')
  Future<Response> getQueue();

  @POST(path: '/player/previous')
  Future<Response> skipPrevious();

  @POST(path: '/player/next')
  Future<Response> skipForward();

  @PUT(path: '/player/pause')
  Future<Response> _pausePlayback();

  @PUT(path: '/player/play')
  Future<Response> _resumePlayback();

  @PUT(path: '/player/play')
  Future<Response> _startFromContext(@Body() Map<String, dynamic> body);

  Future<Response>? startFromContext(dynamic contextUri) {
    if (contextUri.runtimeType == String) {
      return _startFromContext(<String, dynamic>{'context_uri': contextUri});
    } else if (contextUri.runtimeType == List<dynamic>) {
      return _startFromContext(<String, dynamic>{'uris': contextUri});
    }

    return null;
  }

  Future<Response>? playPause() async {
    final Response<dynamic> playbackState = await getPlayerState();
    final bool isPlaying = playbackState.body['is_playing'];

    if (isPlaying == true) {
      await _pausePlayback();
    } else {
      await _resumePlayback();
    }
    
    return playbackState;
  }

  static SpotifyUserService create() {
    final ChopperClient client = ChopperClient(
      baseUrl: Uri.parse('https://api.spotify.com'),
      services: <ChopperService>[_$SpotifyUserService()],
      converter: const JsonConverter(),
      authenticator: SpotifyChopperReauthentication(),
      interceptors: <Interceptor>[SpotifyChopperAuthInterceptor()],
    );
    return _$SpotifyUserService(client);
  }
}
