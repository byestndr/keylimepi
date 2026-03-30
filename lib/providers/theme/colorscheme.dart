import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spotimmich/providers/spotify/spotify_playbackstate.dart';

part 'colorscheme.g.dart';

@riverpod
class appColorScheme extends _$appColorScheme {
  @override
  Future<ColorScheme> build() async {
    final dynamic currentPlaybackState = await ref.watch(
      spotifyPlaybackstateProvider.future,
    );

    return await updateColorScheme(currentPlaybackState);
  }

  Future<ColorScheme> updateColorScheme(dynamic currentPlaybackState) async {
    try {
      final String imageURL =
          currentPlaybackState['item']['album']['images'][0]['url'];
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
