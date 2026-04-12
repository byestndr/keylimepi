import 'dart:async';
import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:http/http.dart' as http;
import 'package:spotimmich/settings/preferences.dart';

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
    return await AsyncPreferences.getStringValue('refresh_token');
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
    await AsyncPreferences.setStringValue('token', accessToken);
    await AsyncPreferences.setStringValue('refresh_token', refreshToken);
  }
}

class SpotifyChopperAuthInterceptor implements Interceptor {
  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    final String? token = await AsyncPreferences.getStringValue('token');

    if (token != null) {
      final request = chain.request.copyWith(
        headers: {...chain.request.headers, 'Authorization': 'Bearer $token'},
      );
      return chain.proceed(request);
    }

    throw Exception('Not authenticated, please log in.');
  }
}
