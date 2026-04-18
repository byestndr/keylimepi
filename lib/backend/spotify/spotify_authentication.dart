import 'dart:async';
import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:spotimmich/settings/preferences.dart';

part 'spotify_authentication.chopper.dart';

@ChopperApi(baseUrl: '/api/token')
abstract class SpotifyAuthenticationService extends ChopperService {
  @POST()
  @formUrlEncoded
  Future<Response> _getAuthToken(@Body() Map<String, dynamic> body);

  Future<Response> getNewAccessToken(String url) async {
    final SpotifySecureStorage storage = SpotifySecureStorage();

    final Uri parsedURI = Uri.parse(url);
    final Map<String, String> queryParameters = parsedURI.queryParameters;
    final String? stateCode = await storage.getStateCode();
    final String? authcode = queryParameters['code'];
    String? codeVerifier = await storage.getCodeVerifier();

    if (!queryParameters.containsKey('state') ||
        queryParameters['state'] != stateCode) {
      codeVerifier = null;
    }

    final Map<String, dynamic> body = <String, dynamic>{
      'grant_type': 'authorization_code',
      'code': authcode,
      'redirect_uri': 'http://127.0.0.1:8080',
      'client_id': 'c92fab18b6924cf7872ed2965644cb25',
      'code_verifier': codeVerifier,
    };

    final Response<dynamic> response = await _getAuthToken(body);

    if (!response.isSuccessful) {
      return response;
    }

    final String authToken = response.body['access_token'];
    final String refreshToken = response.body['refresh_token'];

    await storage.setAuthToken(authToken);
    await storage.setRefreshToken(refreshToken);

    return response;
  }

  static SpotifyAuthenticationService create() {
    final ChopperClient client = ChopperClient(
      baseUrl: Uri.parse('https://accounts.spotify.com'),
      services: <ChopperService>[_$SpotifyAuthenticationService()],
      converter: const JsonConverter()
    );
    return _$SpotifyAuthenticationService(client);
  }
}

class SpotifyURL {
  static final SpotifySecureStorage _storage = SpotifySecureStorage();
  static const String _clientID = 'c92fab18b6924cf7872ed2965644cb25';

  static String getAuthenticationURL() {
    final String codeVerifier = _getSetCodeVerifier();
    final String codeChallenge = _getCodeChallenge(codeVerifier);
    final String stateCode = _getSetStateCode();

    final Map<String, dynamic> queryParameters = <String, dynamic>{
      'client_id': _clientID,
      'response_type': 'code',
      'redirect_uri': 'http://127.0.0.1:8080',
      'code_challenge_method': 'S256',
      'code_challenge': codeChallenge,
      'scope':
          'user-read-playback-state user-modify-playback-state user-read-currently-playing playlist-read-private user-library-read',
      'state': stateCode,
    };

    final Uri spotifyURL = Uri.https(
      'accounts.spotify.com',
      'authorize',
      queryParameters,
    );
    return spotifyURL.toString();
  }

  static String _getSetStateCode() {
    final String stateCode = _generateRandomString(Random().nextInt(30) + 20);
    _storage.setStateCode(stateCode);
    return stateCode;
  }

  static String _getCodeChallenge(String codeVerifier) {
    final Digest codeChallengeDigest = sha256.convert(
      utf8.encode(codeVerifier),
    );
    final String codeChallenge = base64UrlEncode(
      codeChallengeDigest.bytes,
    ).replaceAll('=', '');

    return codeChallenge;
  }

  static String _getSetCodeVerifier() {
    int length = Random().nextInt(85) + 43;
    final String codeVerifier = _generateRandomString(length);
    _storage.setCodeVerifier(codeVerifier);

    return codeVerifier;
  }

  static String _generateRandomString(int length) {
    const String chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final Random random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }
}

class SpotifyChopperReauthentication extends Authenticator {
  static final SpotifySecureStorage _storage = SpotifySecureStorage();

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
        headers: <String, String>{...request.headers, 'Authorization': 'Bearer $accessToken'},
      );
    }
    return null;
  }

  static Future<String?> _getStoredRefreshToken() async {
    return await _storage.getRefreshToken();
  }

  static Future<String> _getNewAccessToken(String refreshToken) async {
    final SpotifyAuthenticationService spotifyAuthentication =
        SpotifyAuthenticationService.create();

    final Map<String, String> body = <String, String>{
      'grant_type': 'refresh_token',
      'refresh_token': refreshToken,
      'client_id': 'c92fab18b6924cf7872ed2965644cb25',
    };

    final Response<dynamic> apiResponse = await spotifyAuthentication._getAuthToken(
      body,
    );

    if (!apiResponse.isSuccessful) {
      throw NotAuthenticatedException('Unable to refresh token');
    }

    final String newAccessToken = apiResponse.body['access_token'];
    final String newRefreshToken = apiResponse.body['refresh_token'];

    await _storeNewToken(newRefreshToken, newAccessToken);

    return newAccessToken;
  }

  static Future<void> _storeNewToken(
    String refreshToken,
    String accessToken,
  ) async {
    await _storage.setAuthToken(accessToken);
    await _storage.setRefreshToken(refreshToken);
  }
}

class SpotifyChopperAuthInterceptor implements Interceptor {
  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    final SpotifySecureStorage storage = SpotifySecureStorage();
    final String? token = await storage.getAuthToken();

    if (token != null) {
      final Request request = chain.request.copyWith(
        headers: <String, String>{...chain.request.headers, 'Authorization': 'Bearer $token'},
      );
      return chain.proceed(request);
    }

    throw NotAuthenticatedException('User not authenticated');
  }
}

class NotAuthenticatedException implements Exception {
  String message;
  NotAuthenticatedException(this.message);

  @override
  String toString() => 'NotAuthenticatedException: $message';
}