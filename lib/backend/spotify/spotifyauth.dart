import 'dart:math';
import 'dart:convert';
import 'package:chopper/chopper.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:spotimmich/settings/preferences.dart';

part 'spotifyauth.chopper.dart';

@ChopperApi(baseUrl: '/authorize')
abstract class SpotifyAuthenticationService extends ChopperService {
  @POST(path: '/api/token')
  Future<Response> getNewToken();

  @POST(path: '/api/token')
  Future<Response> tokenFromRefreshToken();

  static SpotifyAuthenticationService create() {
    final ChopperClient client = ChopperClient(
      baseUrl: Uri.parse('https://accounts.spotify.com'),
      services: [_$SpotifyAuthenticationService()],
      converter: const JsonConverter(),
    );
    return _$SpotifyAuthenticationService(client);
  }
}

class SpotifyAuthentication {
  static final SpotifySecureStorage _storage = SpotifySecureStorage();
  static const String _clientID = 'c92fab18b6924cf7872ed2965644cb25';

  static String getAuthenticationURL() {
    final String codeVerifier = _getSetCodeVerifier();
    final String codeChallenge = _getCodeChallenge(codeVerifier);
    final String stateCode = _getSetStateCode();

    final Map<String, dynamic> queryParameters = {
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

  static Future<int> GetAccessToken(String url) async {
    final Uri parsedURI = Uri.parse(url);
    final Map<String, String> queryParameters = parsedURI.queryParameters;

    // Get stored state code from storage
    String? stateCode = await _storage.getStateCode();
    if (stateCode == null) {
      return 404;
    }

    if (!queryParameters.containsKey('state') ||
        queryParameters['state'] != stateCode) {
      return 400;
    }

    final String? authcode = queryParameters['code'];

    if (authcode == null) {
      return 400;
    }

    final String? code = await _storage.getCodeVerifier();

    if (code == null) {
      return 404;
    }

    final Uri uri = Uri.https('accounts.spotify.com', 'api/token');
    final http.Response response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: <String, dynamic>{
        'grant_type': 'authorization_code',
        'code': authcode,
        'redirect_uri': 'http://127.0.0.1:8080',
        'client_id': 'c92fab18b6924cf7872ed2965644cb25',
        'code_verifier': code,
      },
    );

    final dynamic decodedJSON = jsonDecode(response.body);

    final String? token = decodedJSON['access_token'];

    if (token == null) {
      return 404;
    }

    await _storage.setAuthToken(decodedJSON['access_token']);
    await _storage.setRefreshToken(decodedJSON['refresh_token']);

    return response.statusCode;
  }
}
