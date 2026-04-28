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
  Future<Response<dynamic>> getLyrics() {
    final Uri $url = Uri.parse('/api/get');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getCachedLyrics() {
    final Uri $url = Uri.parse('/api/get-cached');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> searchLyrics() {
    final Uri $url = Uri.parse('/api/search');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }
}
