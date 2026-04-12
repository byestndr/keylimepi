import 'dart:math';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:spotimmich/settings/preferences.dart';


String AuthFlow() {
  int length = Random().nextInt(85) + 43;
  final String codeVerifier = generateRandomString(length);
  AsyncPreferences.setStringValue('code_verifier', codeVerifier);
  final Digest codeChallengeDigest = sha256.convert(utf8.encode(codeVerifier));
  final String codeChallenge = base64UrlEncode(
    codeChallengeDigest.bytes,
  ).replaceAll('=', '');
  final String stateCode = generateRandomString(Random().nextInt(30) + 20);
  const String clientID = 'c92fab18b6924cf7872ed2965644cb25';
  AsyncPreferences.setStringValue('state', stateCode);
  final String spotifyURL =
      'https://accounts.spotify.com/authorize?client_id=$clientID&response_type=code&redirect_uri=http://127.0.0.1:8080&code_challenge_method=S256&code_challenge=$codeChallenge&scope=user-read-playback-state+user-modify-playback-state+user-read-currently-playing+playlist-read-private+user-library-read&state=$stateCode';
  return spotifyURL;
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

Future<int> GetAccessToken(String url) async {
  final Uri parsedURI = Uri.parse(url);
  final Map<String, String> queryParameters = parsedURI.queryParameters;

  // Get stored state code from storage
  String? stateCode = await AsyncPreferences.getStringValue('state');
  if (stateCode == null) {
    return 404;
  }

  if (!queryParameters.containsKey('state') || queryParameters['state'] != stateCode) {
    return 400;
  }
  
  final String? authcode = queryParameters['code'];

  if (authcode == null) {
    return 400;
  }

  final String? code = await AsyncPreferences.getStringValue('code_verifier');

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

  await AsyncPreferences.setStringValue('token', decodedJSON['access_token']);
  await AsyncPreferences.setStringValue('refresh_token', decodedJSON['refresh_token']);

  return response.statusCode;
}

// Future<void> isLoggedIn() async {
//   final String? token = await AsyncPreferences.getStringValue('token');
//   final Uri uri = Uri.https('api.spotify.com', 'v1/me');
//   const int statusCodeError = 400;

//   final http.Response response = await http.get(
//     uri,
//     headers: <String, String>{'Authorization': 'Bearer $token'},
//   );

//   final String? rtoken = await AsyncPreferences.getStringValue('refresh_token');
//   if (rtoken == null) {
//     return;
//   }

//   if (response.statusCode >= statusCodeError) {
//     final Uri refreshUri = Uri.https('accounts.spotify.com', 'api/token');
//     final http.Response refreshResponse = await http.post(
//       refreshUri,
//       headers: <String, String>{'Content-Type': 'application/x-www-form-urlencoded'},
//       body: <String, String>{
//         'grant_type': 'refresh_token',
//         'refresh_token': rtoken,
//         'client_id': 'c92fab18b6924cf7872ed2965644cb25',
//       },
//     );

//     final dynamic refreshBody = jsonDecode(refreshResponse.body);

//     final String accessToken = refreshBody['access_token'];
//     final String newRtoken = refreshBody['refresh_token'];

//     await AsyncPreferences.setStringValue('token', accessToken);
//     await AsyncPreferences.setStringValue('refresh_token', newRtoken);
//   }
// }
