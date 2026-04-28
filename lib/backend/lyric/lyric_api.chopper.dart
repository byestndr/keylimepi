// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'lyric_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$LyricService extends LyricService {
  _$LyricService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = LyricService;

  @override
  Future<Response<dynamic>> getLyrics({
    required String trackName,
    required String artistName,
    required String albumName,
  }) {
    final Uri $url = Uri.parse('/api/get-cached');
    final Map<String, dynamic> $params = <String, dynamic>{
      'track_name': trackName,
      'artist_name': artistName,
      'album_name': albumName,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getUncachedLyrics({
    required String trackName,
    required String artistName,
    required String albumName,
  }) {
    final Uri $url = Uri.parse('/api/get');
    final Map<String, dynamic> $params = <String, dynamic>{
      'track_name': trackName,
      'artist_name': artistName,
      'album_name': albumName,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> searchLyrics() {
    final Uri $url = Uri.parse('/api/search');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }
}
