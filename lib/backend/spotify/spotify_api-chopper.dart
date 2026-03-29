import 'package:chopper/chopper.dart';
import 'dart:async';

import 'package:spotimmich/backend/spotify/spotify_authentication.dart';
import 'package:spotimmich/settings/preferences.dart';

part 'spotify_api-chopper.chopper.dart';

@ChopperApi(baseUrl: '/v1/me')
abstract class SpotifyUserService extends ChopperService {
  @GET(path: "/player")
  Future<Response> getPlayerState();

  static SpotifyUserService create() {
    final client = ChopperClient(
      baseUrl: Uri.parse('https://api.spotify.com'),
      services: [_$SpotifyUserService()],
      converter: const JsonConverter(),
      authenticator: SpotifyChopperReauthentication(),
      interceptors: [SpotifyChopperAuthInterceptor()],
    );
    return _$SpotifyUserService(client);
  }
}
