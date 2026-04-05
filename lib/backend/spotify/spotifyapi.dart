import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:spotimmich/settings/preferences.dart';

class Interactions {
  final String base = 'api.spotify.com';
  final String path = 'v1/me';

  Future<Map<String, String>> _getHeaders() async {
    final String? token = await AsyncPreferences().getStringValue('token');
    final Map<String, String> headers = <String, String>{
      'Authorization': 'Bearer $token',
    };

    return headers;
  }

  Future<void> _putRequest(
    String endpoint, {
    Map<String, dynamic>? params,
    String? body,
  }) async {
    final Uri uri = Uri.https(base, '$path/$endpoint', params);
    final Map<String, String> headers = await _getHeaders();
    await http.put(uri, headers: headers, body: body);
  }

  Future<http.Response> _getRequest(String endpoint) async {
    final Uri uri = Uri.https(base, '$path/$endpoint');
    final Map<String, String> headers = await _getHeaders();

    final http.Response response = await http.get(uri, headers: headers);
    return response;
  }

  Future<String> getPlaybackState() async {
    final http.Response response = await _getRequest('player');
    return response.body;
  }

  Future<void> seekSong(int position) async {
    final Map<String, String> parameters = <String, String>{
      'position_ms': '$position',
    };
    await _putRequest('player/seek', params: parameters);
  }

  Future<bool> shuffleToggle() async {
    final String response = await getPlaybackState();
    final dynamic body = jsonDecode(response);
    final bool currentState = body['shuffle_state'];
    bool newState = false;

    if (currentState == false) {
      newState = true;
    } else {
      newState = false;
    }

    final Map<String, String> parameters = <String, String>{
      'state': '$newState',
    };
    await _putRequest('player/shuffle', params: parameters);

    return newState;
  }

  Future<String> repeatState() async {
    final String response = await getPlaybackState();
    final dynamic body = jsonDecode(response);
    final String currentState = body['repeat_state'];
    String newState = 'off';

    switch (currentState) {
      case 'off':
        newState = 'context';
        break;
      case 'context':
        newState = 'track';
        break;
      case 'track':
        newState = 'off';
        break;
      default:
        newState = 'off';
        break;
    }

    final Map<String, String> parameters = <String, String>{
      'state': '$newState',
    };
    await _putRequest('player/repeat', params: parameters);

    return newState;
  }
}
