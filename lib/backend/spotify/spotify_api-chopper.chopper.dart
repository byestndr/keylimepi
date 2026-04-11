// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'spotify_api-chopper.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$SpotifyUserService extends SpotifyUserService {
  _$SpotifyUserService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = SpotifyUserService;

  @override
  Future<Response<dynamic>> getPlayerState() {
    final Uri $url = Uri.parse('/v1/me/player');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getPlaylists() {
    final Uri $url = Uri.parse('/v1/me/playlists');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getAlbums() {
    final Uri $url = Uri.parse('/v1/me/albums');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getLikedSongs() {
    final Uri $url = Uri.parse('/v1/me/tracks');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getQueue() {
    final Uri $url = Uri.parse('/v1/me/player/queue');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> skipPrevious() {
    final Uri $url = Uri.parse('/v1/me/player/previous');
    final Request $request = Request('POST', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> skipForward() {
    final Uri $url = Uri.parse('/v1/me/player/next');
    final Request $request = Request('POST', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> seekSong(int position) {
    final Uri $url = Uri.parse('/v1/me/player/seek');
    final Map<String, dynamic> $params = <String, dynamic>{
      'position_ms': position,
    };
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> cycleRepeat(String repeatState) {
    final Uri $url = Uri.parse('/v1/me/player/repeat');
    final Map<String, dynamic> $params = <String, dynamic>{
      'state': repeatState,
    };
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> shuffleToggle(bool isShuffled) {
    final Uri $url = Uri.parse('/v1/me/player/shuffle');
    final Map<String, dynamic> $params = <String, dynamic>{'state': isShuffled};
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _pausePlayback() {
    final Uri $url = Uri.parse('/v1/me/player/pause');
    final Request $request = Request('PUT', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _resumePlayback() {
    final Uri $url = Uri.parse('/v1/me/player/play');
    final Request $request = Request('PUT', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _startFromContext(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/v1/me/player/play');
    final $body = body;
    final Request $request = Request('PUT', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }
}
