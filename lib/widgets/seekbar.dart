import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:spotimmich/settings/spotify/spotifyapi.dart';

class ProgressSlider extends StatefulWidget {
  const ProgressSlider({super.key});

  @override
  State<ProgressSlider> createState() => _ProgressSliderState();
}

class _ProgressSliderState extends State<ProgressSlider> {
  double sliderPos = 0;
  double maxPos = 3600000;
  Timer? timer;
  int refreshCount = 20;

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
    if (refreshCount < 30) {
      refreshCount++;
      setState(() {
        if (sliderPos + 200 <= maxPos) {
          sliderPos = sliderPos + 200;
        }
      });
      return;
    }

    try {
      final dynamic body = jsonDecode(
        await Interactions().cachedPlaybackStateResponse(
          functionName: 'ProgressSlider',
        ),
      );

      if (body['is_playing'] == false) {
        return;
      }

      if (!mounted) {
        return;
      }

      setState(() {
        try {
          int pos = body['item']['duration_ms'];
          maxPos = pos.toDouble();
          int currentpos = body['progress_ms'];
          sliderPos = currentpos.toDouble();
          refreshCount = 0;
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
          Interactions().seekSong(currentPosition);
        },
      ),
    );
  }
}
