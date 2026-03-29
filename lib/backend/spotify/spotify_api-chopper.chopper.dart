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
}
