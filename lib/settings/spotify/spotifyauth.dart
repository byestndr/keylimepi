import 'dart:math';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final preferences Preferences = preferences();

String AuthFlow() {
  int length = Random().nextInt(85) + 43;
  final String codeVerifier = generateRandomString(length);
  Preferences.setStringValue('code_verifier', codeVerifier);
  final Digest codeChallengeDigest = sha256.convert(utf8.encode(codeVerifier));
  final String codeChallenge = base64UrlEncode(
    codeChallengeDigest.bytes,
  ).replaceAll('=', '');
  final String stateCode = generateRandomString(Random().nextInt(30) + 20);
  const String clientID = 'c92fab18b6924cf7872ed2965644cb25';
  Preferences.setStringValue('state', stateCode);
  final String spotifyURL =
      'https://accounts.spotify.com/authorize?client_id=$clientID&response_type=code&redirect_uri=http://127.0.0.1:8080&code_challenge_method=S256&code_challenge=$codeChallenge&scope=user-read-playback-state+user-modify-playback-state+user-read-currently-playing+playlist-read-private&state=$stateCode';
  return spotifyURL;
}

class preferences {
  final SharedPreferencesAsync prefs = SharedPreferencesAsync();

  Future<void> setStringValue(String key, String value) async {
    await prefs.remove(key);
    await prefs.setString(key, value);
  }

  Future<String?> getStringValue(String key) async {
    final String? value = await prefs.getString(key);
    return value;
  }

  Future<void> setIntValue(String key, int value) async{
    await prefs.remove(key);
    await prefs.setInt(key, value);
  }

  Future<void> removeIntValue(String key) async{
    await prefs.remove(key);
  }

  Future<int?> getIntValue(String key) async{
    final int? value = await prefs.getInt(key);
    return value;
  }

  Future<void> ClearPreferences() async {
    await prefs.clear();
  }
}

String generateRandomString(int length) {
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

Future<dynamic> parseURL(String url) async {
  String? stateCode = await Preferences.getStringValue('state');
  if (stateCode == null) {
    return 404;
  }

  final String splicedURL = url.replaceAll('http://127.0.0.1:8080/?code=', '');

  if (splicedURL.contains('&state=$stateCode') == false) {
    return 400;
  }

  final String finalURL = splicedURL.replaceAll('&state=$stateCode', '');
  return finalURL;
}

Future<int?> GetAccessToken(String url) async {
  final dynamic authcode = await parseURL(url);

  if (authcode.runtimeType == int) {
    return 400;
  }

  final String? code = await Preferences.getStringValue('code_verifier');

  if (code == null) {
    return 404;
  }

  final Uri uri = Uri.https('accounts.spotify.com', 'api/token');
  final http.Response response = await http.post(
    uri,
    headers: <String, String>{'Content-Type': 'application/x-www-form-urlencoded'},
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

  await Preferences.setStringValue('token', decodedJSON['access_token']);
  await Preferences.setStringValue('refresh_token', decodedJSON['refresh_token']);

  return response.statusCode;
}

Future<void> isLoggedIn() async {
  final String? token = await Preferences.getStringValue('token');
  final Uri uri = Uri.https('api.spotify.com', 'v1/me');
  const int StatusCodeError = 400;

  final http.Response response = await http.get(
    uri,
    headers: <String, String>{'Authorization': 'Bearer $token'},
  );

  final String? rtoken = await Preferences.getStringValue('refresh_token');
  if (rtoken == null) {
    return;
  }

  if (response.statusCode >= StatusCodeError) {
    final Uri refresh_uri = Uri.https('accounts.spotify.com', 'api/token');
    final http.Response refresh_response = await http.post(
      refresh_uri,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'grant_type': 'refresh_token',
        'refresh_token': rtoken,
        'client_id': 'c92fab18b6924cf7872ed2965644cb25',
      },
    );

    final dynamic refresh_body = jsonDecode(refresh_response.body);

    final String access_token = refresh_body['access_token'];
    final String new_rtoken = refresh_body['refresh_token'];

    await Preferences.setStringValue('token', access_token);
    await Preferences.setStringValue('refresh_token', new_rtoken);
  }
}
