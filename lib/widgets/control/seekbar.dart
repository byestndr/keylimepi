import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotimmich/backend/spotify/spotify_api.dart';
import 'package:spotimmich/providers/spotify/seekbar_provider.dart';
import 'dart:async';
import 'package:spotimmich/providers/spotify/spotify_playbackstate.dart';

class ProgressSlider extends ConsumerWidget {
  const ProgressSlider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SeekbarTime currentSliderPosition = ref.watch(
      seekbarPositionProvider,
    );
    ref.watch(seekbarTimerProvider);

    return SliderTheme(
      data: const SliderThemeData(year2023: false),
      child: Slider(
        value: currentSliderPosition.currentPosition.inMilliseconds.toDouble(),
        min: 0,
        max: currentSliderPosition.maxPosition.inMilliseconds.toDouble(),
        onChanged: (double value) {
          ref.read(seekbarPositionProvider.notifier).setSliderPos(value);
        },
        onChangeEnd: (double value) {
          int currentPosition = value.toInt();
          final SpotifyUserService spotifyAPI = SpotifyUserService.create();
          spotifyAPI.seekSong(currentPosition);
        },
      ),
    );
  }
}
