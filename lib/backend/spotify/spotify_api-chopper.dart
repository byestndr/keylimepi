import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'dart:async';

import 'package:http/http.dart' as http;
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
      interceptors: [SpotifyChopperAuthentication()],
    );
    return _$SpotifyUserService(client);
  }
}

class SpotifyChopperAuthentication implements Interceptor {
  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    final AsyncPreferences Preferences = AsyncPreferences();
    final String? token = await Preferences.getStringValue('token');

    final request = chain.request.copyWith(
      headers: {...chain.request.headers, 'Authorization': 'Bearer $token'},
    );

    return chain.proceed(request);
  }
}

class SpotifyChopperReauthentication extends Authenticator {
  @override
  FutureOr<Request?> authenticate(
    Request request,
    Response<dynamic> response, [
    Request? originalRequest,
  ]) async {
    if (response.statusCode == 401) {
      final String? refreshToken = await _getStoredRefreshToken();

      if (refreshToken == null) {
        return null;
      }

      final String accessToken = await _getNewAccessToken(refreshToken);
      return request.copyWith(
        headers: {...request.headers, 'Authorization': 'Bearer $accessToken'},
      );
    }
    return null;
  }

  static Future<String?> _getStoredRefreshToken() async {
    final AsyncPreferences Preferences = AsyncPreferences();
    return await Preferences.getStringValue('refresh_token');
  }

  static Future<String> _getNewAccessToken(String refreshToken) async {
    final Uri spotifyRefreshURI = Uri.https(
      'accounts.spotify.com',
      'api/token',
    );
    final http.Response authorizationResponse = await http.post(
      spotifyRefreshURI,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: <String, String>{
        'grant_type': 'refresh_token',
        'refresh_token': refreshToken,
        'client_id': 'c92fab18b6924cf7872ed2965644cb25',
      },
    );

    final dynamic apiResponse = jsonDecode(authorizationResponse.body);
    final String newAccessToken = apiResponse['access_token'];
    final String newRefreshToken = apiResponse['refresh_token'];

    await _storeNewToken(newRefreshToken, newAccessToken);

    return newAccessToken;
  }

  static Future<void> _storeNewToken(
    String refreshToken,
    String accessToken,
  ) async {
    final AsyncPreferences Preferences = AsyncPreferences();

    await Preferences.setStringValue('token', accessToken);
    await Preferences.setStringValue('refresh_token', refreshToken);
  }
}