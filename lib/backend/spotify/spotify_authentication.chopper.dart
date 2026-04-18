// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'spotify_authentication.dart';

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
  Future<Response<dynamic>> _getAuthToken(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/api/token');
    final Map<String, String> $headers = {
      'content-type': 'application/x-www-form-urlencoded',
    };
    final $body = body.map<String, String>((key, value) {
      return MapEntry(key.toString(), value.toString());
    });
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      headers: $headers,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
