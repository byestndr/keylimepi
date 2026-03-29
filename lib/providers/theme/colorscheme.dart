import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:convert';
import 'package:spotimmich/backend/spotify/spotifyapi.dart';

part 'colorscheme.g.dart';

@riverpod
class appColorScheme extends _$appColorScheme {
  @override
  Future<ColorScheme> build() async {
    return await updateColorScheme();
  }

  Future<ColorScheme> updateColorScheme() async {
    final String playstate = await Interactions().cachedPlaybackStateResponse(
      functionName: 'ColorScheme',
    );

    try {
      final dynamic body = jsonDecode(playstate);
      final String imageURL = body['item']['album']['images'][0]['url'];
      return ColorScheme.fromImageProvider(
        brightness: Brightness.dark,
        provider: NetworkImage(imageURL),
      );
    } on FormatException {
      return ColorScheme.fromSeed(
        seedColor: Colors.lightGreen,
        brightness: Brightness.dark,
      );
    } on NoSuchMethodError {
      return ColorScheme.fromSeed(
        seedColor: Colors.lightGreen,
        brightness: Brightness.dark,
      );
    }
  }

  void refreshColorscheme() {
    ref.invalidateSelf();
  }
}
