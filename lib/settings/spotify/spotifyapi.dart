import 'dart:convert';

import 'package:http/http.dart' as http;
import 'spotifyauth.dart';

class Interactions {
  final String base = 'api.spotify.com';
  final String path = 'v1/me/player';

  Future<Map<String, String>> _getHeaders() async {
    final token = await preferences().getStringValue('token');
    final headers = {'Authorization': 'Bearer $token'};

    return headers;
  }

  void _putRequest(String endpoint, {Map<String, dynamic>? params}) async {
    final uri = Uri.https(base, '$path/$endpoint', params);
    final headers = await _getHeaders();

    http.put(uri, headers: headers);
  }

  Future<http.Response> _getRequest(String endpoint) async {
    final uri = Uri.https(base, '$path/$endpoint');
    final headers = await _getHeaders();

    final response = await http.get(uri, headers: headers);
    return response;
  }

  void _postRequest(endpoint) async {
    final uri = Uri.https(base, '$path/$endpoint');
    final headers = await _getHeaders();

    http.post(uri, headers: headers);
  }

  Future<String> cachedPlaybackStateResponse({
    required String functionName,
  }) async {
    // Rankings, 0 -> New Response only, 1 -> Pull responses sometimes, 2 -> Only use old responses
    const Map<String, int> functionImportance = {
      'ProgressSlider': 0,
      'SongImage': 1,
      'SongInfo': 1,
      'Controls': 0,
      'ColorScheme': 2,
    };

    const int maxBeforeNewRequest = 15;

    switch (functionImportance[functionName]) {
      case 0:
        final String response = await getPlaybackState();
        preferences().setStringValue('response', response);
        return response;
      case 2:
        String? response = await preferences().getStringValue('response');
        if (response == null) {
          final String newResponse = await getPlaybackState();
          preferences().setStringValue('response', newResponse);
          return newResponse;
        } else {
          return response;
        }
      default:
        int? counter = await preferences().getIntValue(
          'playback_state_counter',
        );

        if (counter == null || counter == maxBeforeNewRequest) {
          const int newCounter = 1;
          preferences().setIntValue('playback_state_counter', newCounter);
          final String response = await getPlaybackState();
          return response;
        }

        final int newCounter = counter++;
        preferences().setIntValue('playback_state_counter', newCounter);

        String? response = await preferences().getStringValue('response');
        if (response == null) {
          final http.Response newResponse = await _getRequest('');
          preferences().setStringValue('response', newResponse.body);
          return newResponse.body;
        } else {
          return response;
        }
    }
  }

  Future<String> getPlaybackState() async {
    final http.Response response = await _getRequest('');
    return response.body;
  }

  void pausePlayback() async {
    _putRequest('pause');
  }

  void resumePlayback() async {
    _putRequest('play');
  }

  void skipPrevious() async {
    _postRequest('previous');
  }

  void skipNext() async {
    _postRequest('next');
  }

  void seekSong(position) async {
    final parameters = {'position_ms': '$position'};
    _putRequest('seek', params: parameters);
  }

  Future<bool> shuffleToggle() async {
    final String response = await getPlaybackState();
    final body = jsonDecode(response);
    final currentState = body['shuffle_state'];
    bool newState = false;

    if (currentState == false) {
      newState = true;
    } else {
      newState = false;
    }

    final parameters = {'state': '$newState'};
    _putRequest('shuffle', params: parameters);

    return newState;
  }

  Future<bool> pauseToggle() async {
    final String response = await getPlaybackState();
    final body = jsonDecode(response);
    final isPlaying = body['is_playing'];
    bool newState = false;
    if (isPlaying == true) {
      newState = false;
      pausePlayback();
    } else {
      newState = true;
      resumePlayback();
    }
    return newState;
  }

  Future<String> repeatState() async {
    final String response = await getPlaybackState();
    final body = jsonDecode(response);
    final currentState = body['repeat_state'];
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

    final parameters = {'state': '$newState'};
    _putRequest('repeat', params: parameters);

    return newState;
  }
}
