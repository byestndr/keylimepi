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

  Future<void> _postRequest(String endpoint) async {
    final Uri uri = Uri.https(base, '$path/$endpoint');
    final Map<String, String> headers = await _getHeaders();

    await http.post(uri, headers: headers);
  }

  Future<String> getPlaybackState() async {
    final http.Response response = await _getRequest('player');
    return response.body;
  }

  Future<String> getSavedAlbums() async {
    final http.Response response = await _getRequest('albums');
    await AsyncPreferences().setStringValue('saved_albums', response.body);
    return response.body;
  }

  Future<String> getCachedAlbums() async {
    String? albums = await AsyncPreferences().getStringValue('saved_albums');
    if (albums == null) {
      return await getSavedAlbums();
    }
    return albums;
  }

  Future<String> getLikedSongs() async {
    final http.Response response = await _getRequest('tracks');
    await AsyncPreferences().setStringValue('liked_songs', response.body);
    return response.body;
  }

  Future<String> getCachedSongs() async {
    String? songs = await AsyncPreferences().getStringValue('liked_songs');
    if (songs == null) {
      return await getLikedSongs();
    }
    return songs;
  }

  Future<String> getQueue() async {
    final http.Response response = await _getRequest('player/queue');
    return response.body;
  }

  Future<void> pausePlayback() async {
    await _putRequest('player/pause');
  }

  Future<void> resumePlayback({String? context_uri}) async {
    String body = '';

    if (context_uri == null) {
      await _putRequest('player/play');
      return;
    }

    if (context_uri != '' && context_uri.contains('track')) {
      final Map<String, List<String>> bodyMap = <String, List<String>>{
        'uris': <String>[context_uri],
      };
      body = jsonEncode(bodyMap);
    } else if (context_uri != '') {
      final Map<String, String> bodyMap = <String, String>{
        'context_uri': context_uri,
      };
      body = jsonEncode(bodyMap);
    }

    await _putRequest('player/play', body: body);
  }

  Future<void> skipPrevious() async {
    await _postRequest('player/previous');
  }

  Future<void> skipNext() async {
    await _postRequest('player/next');
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

  Future<bool> pauseToggle() async {
    final String response = await getPlaybackState();
    final dynamic body = jsonDecode(response);
    final bool isPlaying = body['is_playing'];
    bool newState = false;
    if (isPlaying == true) {
      newState = false;
      await pausePlayback();
    } else {
      newState = true;
      await resumePlayback();
    }
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
