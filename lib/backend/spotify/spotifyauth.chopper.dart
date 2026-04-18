// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'spotifyauth.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$SpotifyAuthenticationService
    extends SpotifyAuthenticationService {
  _$SpotifyAuthenticationService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = SpotifyAuthenticationService;

  @override
  Future<Response<dynamic>> getNewToken() {
    final Uri $url = Uri.parse('/authorize/api/token');
    final Request $request = Request('POST', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> tokenFromRefreshToken() {
    final Uri $url = Uri.parse('/authorize/api/token');
    final Request $request = Request('POST', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }
}
