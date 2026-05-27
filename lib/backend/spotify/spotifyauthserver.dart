import 'package:flutter/material.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'dart:io';
import 'package:chopper/chopper.dart' as chopper;

import 'package:key_limepi/backend/spotify/spotify_authentication.dart';

class Server {
  HttpServer? server;
  late BuildContext newcontext;

  Future<Response> handler(Request request) async {
    final Uri returnedURL = request.requestedUri;
    final SpotifyAuthenticationService authenticationService =
        SpotifyAuthenticationService.create();
    final chopper.Response<dynamic> authenticatorResponse =
        await authenticationService.getNewAccessToken(returnedURL.toString());

    if (!authenticatorResponse.isSuccessful) {
      return Response.badRequest(
        body: 'Error logging into Spotify, try again.',
      );
    }

    if (!request.requestedUri.queryParameters.containsKey('code') &&
        !request.requestedUri.queryParameters.containsKey('code')) {
      return Response.badRequest(body: 'Error parsing the URL, try again.');
    }

    Future.delayed(const Duration(seconds: 1), () {
      server!.close(force: true);
      Navigator.of(newcontext).pop(true);
    });
    return Response.ok('Authorized! You may now close this page.');
  }

  void stopServer() {
    server!.close(force: true);
    return;
  }

  Future<void> startServer(BuildContext context) async {
    server = await shelf_io.serve(handler, InternetAddress.anyIPv4, 8080);

    newcontext = context;
    return;
  }
}
