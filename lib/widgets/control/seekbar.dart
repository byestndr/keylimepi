import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotimmich/backend/spotify/spotify_api-chopper.dart';
import 'dart:async';
import 'package:spotimmich/providers/spotify/spotify_playbackstate.dart';

class ProgressSlider extends ConsumerStatefulWidget {
  const ProgressSlider({super.key});

  @override
  ConsumerState<ProgressSlider> createState() => _ProgressSliderState();
}

class _ProgressSliderState extends ConsumerState<ProgressSlider> {
  double sliderPos = 0;
  double maxPos = 3600000;
  Timer? timer;
  int refreshCount = 20;
  bool _isPaused = true;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(milliseconds: 200), (
      Timer timer,
    ) async {
      await RefreshLoop();
    });
  }

  Future<void> RefreshLoop() async {
    if (refreshCount < 30 && _isPaused) {
      refreshCount++;
      setState(() {
        if (sliderPos + 200 <= maxPos) {
          sliderPos = sliderPos + 200;
        }
      });
      return;
    }

    try {
      final dynamic currentPlaybackState = await ref.watch(
        spotifyPlaybackstateProvider.future,
      );

      if (currentPlaybackState.statusCode == 204) {
        maxPos = 1;
        sliderPos = 0;
        return;
      }

      if (!mounted) {
        return;
      }

      setState(() {
        try {
          _isPaused = false;
          int pos = currentPlaybackState.body['item']['duration_ms'];
          maxPos = pos.toDouble();
          int currentpos = currentPlaybackState.body['progress_ms'];
          sliderPos = currentpos.toDouble();
          refreshCount = 0;
          _isPaused = currentPlaybackState.body['is_playing'];
        } on NoSuchMethodError {
          maxPos = 1;
          sliderPos = 0;
        }
      });
    } on FormatException {
      maxPos = 1;
      sliderPos = 0;
      return;
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: const SliderThemeData(year2023: false),
      child: Slider(
        value: sliderPos,
        min: 0,
        max: maxPos,
        onChanged: (double value) {
          setState(() {
            sliderPos = value;
          });
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
