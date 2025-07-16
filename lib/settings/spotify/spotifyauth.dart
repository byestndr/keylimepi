import 'dart:math';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

var Preferences = preferences();

String AuthFlow() {
  int length = Random().nextInt(85) + 43;
  final codeVerifier = generateRandomString(length);
  Preferences.setStringValue('code_verifier', codeVerifier);
  final codeChallengeDigest = sha256.convert(utf8.encode(codeVerifier));
  final codeChallenge = base64UrlEncode(
    codeChallengeDigest.bytes,
  ).replaceAll('=', '');
  final stateCode = generateRandomString(Random().nextInt(30) + 20);
  const String clientID = 'c92fab18b6924cf7872ed2965644cb25';
  Preferences.setStringValue('state', stateCode);
  final String spotifyURL =
      'https://accounts.spotify.com/authorize?client_id=$clientID&response_type=code&redirect_uri=http://127.0.0.1:8080&code_challenge_method=S256&code_challenge=$codeChallenge&scope=user-read-playback-state+user-modify-playback-state+user-read-currently-playing&state=$stateCode';
  return spotifyURL;
}

class preferences {
  final SharedPreferencesAsync prefs = SharedPreferencesAsync();

  void setStringValue(String key, String value) async {
    await prefs.remove(key);
    await prefs.setString(key, value);
  }

  Future<String?> getStringValue(String key) async {
    final String? value = await prefs.getString(key);
    return value;
  }

  void setIntValue(String key, int value) async{
    await prefs.remove(key);
    await prefs.setInt(key, value);
  }

  void removeIntValue(String key) async{
    await prefs.remove(key);
  }

  Future<int?> getIntValue(String key) async{
    final int? value = await prefs.getInt(key);
    return value;
  }

  void ClearPreferences() async {
    print('Clearing prefs');
    await prefs.clear();
  }
}

String generateRandomString(int length) {
  const chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final random = Random();
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

  final splicedURL = url.replaceAll('http://127.0.0.1:8080/?code=', '');

  if (splicedURL.contains('&state=$stateCode') == false) {
    return 400;
  }

  final finalURL = splicedURL.replaceAll('&state=$stateCode', '');
  return finalURL;
}

Future<int?> GetAccessToken(url) async {
  final authcode = await parseURL(url);

  if (authcode.runtimeType == int) {
    return 400;
  }

  final code = await Preferences.getStringValue('code_verifier');
  final uri = Uri.https('accounts.spotify.com', 'api/token');
  var response = await http.post(
    uri,
    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    body: {
      'grant_type': 'authorization_code',
      'code': authcode,
      'redirect_uri': 'http://127.0.0.1:8080',
      'client_id': 'c92fab18b6924cf7872ed2965644cb25',
      'code_verifier': code,
    },
  );

  final decodedJSON = jsonDecode(response.body);

  final token = decodedJSON['access_token'];

  if (token == null) {
    return 404;
  }

  Preferences.setStringValue('token', decodedJSON['access_token']);
  Preferences.setStringValue('refresh_token', decodedJSON['refresh_token']);

  return response.statusCode;
}

void isLoggedIn() async {
  final token = await Preferences.getStringValue('token');
  final uri = Uri.https('api.spotify.com', 'v1/me');
  const int StatusCodeError = 400;

  var response = await http.get(
    uri,
    headers: {'Authorization': 'Bearer $token'},
  );

  final rtoken = await Preferences.getStringValue('refresh_token');
  if (rtoken == null) {
    return;
  }

  if (response.statusCode >= StatusCodeError) {
    print('Refreshing token');
    final refresh_uri = Uri.https('accounts.spotify.com', 'api/token');
    var refresh_response = await http.post(
      refresh_uri,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'grant_type': 'refresh_token',
        'refresh_token': rtoken,
        'client_id': 'c92fab18b6924cf7872ed2965644cb25',
      },
    );

    final refresh_body = jsonDecode(refresh_response.body);

    final access_token = refresh_body['access_token'];
    final new_rtoken = refresh_body['refresh_token'];

    Preferences.setStringValue('token', access_token);
    Preferences.setStringValue('refresh_token', new_rtoken);
  }
}
