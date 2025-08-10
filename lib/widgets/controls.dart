import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:spotimmich/settings/spotify/spotifyapi.dart';

class PlaybackControls extends StatefulWidget {
  final Function(bool) isExpanded;
  const PlaybackControls({super.key, required this.isExpanded});

  @override
  State<PlaybackControls> createState() => _PlaybackControlsState();
}

class _PlaybackControlsState extends State<PlaybackControls> {
  IconData pauseStatus = Icons.pause;
  Timer? timer;
  IconData shuffleStatus = Icons.shuffle;
  IconData repeatStatus = Icons.repeat;
  bool queueExpanded = false;
  late Function(bool) isExpandedCallback;
  static const double iconButtonDensityHorizontal = 1;
  static const double iconButtonDensityVertical = 1;

  @override
  void initState() {
    super.initState();
    isExpandedCallback = widget.isExpanded;

    timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      RefreshLoop();
    });
  }

  void RefreshLoop() {
    setState(() {
      Interactions().cachedPlaybackStateResponse(functionName: 'Controls').then(
        (String value) {
          try {
            final dynamic body = jsonDecode(value);
            final bool paused = body['is_playing'];
            final bool shuffled = body['shuffle_state'];
            final String repeatstate = body['repeat_state'];
            paused == false
                ? pauseStatus = Icons.play_arrow
                : pauseStatus = Icons.pause;
            shuffled == false
                ? shuffleStatus = Icons.shuffle
                : shuffleStatus = Icons.shuffle_on_rounded;
            if (repeatstate == 'context') {
              repeatStatus = Icons.repeat_on_rounded;
            } else if (repeatstate == 'track') {
              repeatStatus = Icons.repeat_one_on_rounded;
            } else {
              repeatStatus = Icons.repeat;
            }
          } on FormatException {
            pauseStatus = Icons.play_arrow;
            shuffleStatus = Icons.shuffle;
            repeatStatus = Icons.repeat;
          } on TypeError {
            pauseStatus = Icons.play_arrow;
            shuffleStatus = Icons.shuffle;
            repeatStatus = Icons.repeat;
          }
        },
      );
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        FloatingActionButton.large(
          onPressed: () {
            Interactions().pauseToggle().then((bool value) {
              setState(() {
                if (value == true) {
                  pauseStatus = Icons.pause;
                } else {
                  pauseStatus = Icons.play_arrow;
                }
              });
            });
          },
          child: Icon(pauseStatus),
        ),
        // Previous button
        IconButton.filled(
          onPressed: () {
            Interactions().skipPrevious();
          },
          icon: const Icon(Icons.skip_previous),
          iconSize: 30,
          visualDensity: const VisualDensity(
            horizontal: iconButtonDensityHorizontal,
            vertical: iconButtonDensityVertical,
          ),
          style: IconButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(16),
            ),
          ),
        ),
        // Next button
        IconButton.filled(
          onPressed: () {
            Interactions().skipNext();
          },
          icon: const Icon(Icons.skip_next),
          iconSize: 30,
          visualDensity: const VisualDensity(
            horizontal: iconButtonDensityHorizontal,
            vertical: iconButtonDensityVertical,
          ),
          style: IconButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(16),
            ),
          ),
        ),
        // Repeat button
        IconButton.filled(
          onPressed: () {
            Interactions().repeatState().then((String value) {
              setState(() {
                if (value == 'context') {
                  repeatStatus = Icons.repeat_on_rounded;
                } else if (value == 'track') {
                  repeatStatus = Icons.repeat_one_on_rounded;
                } else {
                  repeatStatus = Icons.repeat;
                }
              });
            });
          },
          icon: Icon(repeatStatus),
          iconSize: 30,
          visualDensity: const VisualDensity(
            horizontal: iconButtonDensityHorizontal,
            vertical: iconButtonDensityVertical,
          ),
          style: IconButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(16),
            ),
          ),
        ),
        // Shuffle button
        IconButton.filled(
          onPressed: () {
            Interactions().shuffleToggle().then((bool value) {
              setState(() {
                if (value == false) {
                  shuffleStatus = Icons.shuffle;
                } else {
                  shuffleStatus = Icons.shuffle_on_rounded;
                }
              });
            });
          },
          icon: Icon(shuffleStatus),
          iconSize: 30,
          visualDensity: const VisualDensity(
            horizontal: iconButtonDensityHorizontal,
            vertical: iconButtonDensityVertical,
          ),
          style: IconButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(16),
            ),
          ),
        ),
        IconButton.filled(
          onPressed: () {
            queueExpanded = !queueExpanded;
            isExpandedCallback(queueExpanded);
          },
          icon: const Icon(Icons.queue_music_rounded),
          iconSize: 30,
          visualDensity: const VisualDensity(horizontal: 1, vertical: 1),
          style: IconButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(16),
            ),
          ),
        ),
      ],
    );
  }
}

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
