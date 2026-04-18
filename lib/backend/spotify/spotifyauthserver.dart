import 'package:flutter/material.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'dart:io';

import 'package:spotimmich/backend/spotify/spotifyauth.dart';


class Server {
  HttpServer? server;
  late BuildContext newcontext;

  Future<Response> handler(Request request) async {
    final Uri returnedURL = request.requestedUri;

    final int authorizationStatus = await SpotifyAuthentication.GetAccessToken(
      returnedURL.toString(),
    );

    if (authorizationStatus >= 300) {
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
      Navigator.of(newcontext).pop();
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