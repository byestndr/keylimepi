import 'dart:async';

import 'package:key_limepi/providers/spotify/song_info_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:key_limepi/providers/spotify/spotify_playbackstate.dart';

part 'seekbar_provider.g.dart';

class SeekbarTime {
  Duration currentPosition;
  Duration maxPosition;
  int refreshCount;

  SeekbarTime({
    required this.currentPosition,
    required this.maxPosition,
    this.refreshCount = 0,
  });
}

@riverpod
class SeekbarTimer extends _$SeekbarTimer {
  Timer? _timer;

  @override
  int build() {
    ref.onDispose(() {
      _timer?.cancel();
    });

    startTimer();

    return 0;
  }

  void startTimer() async {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      ref.read(seekbarPositionProvider.notifier).updateSliderPosition();
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }
}

@Riverpod(keepAlive: true)
class SeekbarPosition extends _$SeekbarPosition {
  @override
  SeekbarTime build() {
    return SeekbarTime(
      currentPosition: const Duration(),
      maxPosition: const Duration(milliseconds: 360000),
    );
  }

  void setSliderPos(double position) {
    state = SeekbarTime(
      currentPosition: Duration(milliseconds: position.toInt()),
      maxPosition: state.maxPosition,
    );
    return;
  }

  FutureOr<void> updateSliderPosition() async {
    final bool isPaused = ref.read(seekbarPauseProvider);

    // Checks if we need to pull a new state.
    if (_isNewState()) {
      await _getNewSliderPosition();
      return;
    }

    if (isPaused) {
      return;
    }
    // print(state.currentPosition);
    _incrementSliderPosition();

    // If it's the end of the song, we pull the new
    // playback state to get the new song.
    if (state.currentPosition == state.maxPosition) {
      ref.invalidate(spotifyPlaybackStateProvider);
    }

    return;
  }

  bool _isNewState() {
    final bool isPaused = ref.read(seekbarPauseProvider);
    return state.currentPosition.inMilliseconds == 0 ||
        isPaused ||
        state.refreshCount == 25;
  }

  void _incrementSliderPosition() {
    late int newPosition;
    if (state.currentPosition.inMilliseconds + 200 <=
        state.maxPosition.inMilliseconds) {
      newPosition = state.currentPosition.inMilliseconds + 200;
    } else {
      newPosition = state.currentPosition.inMilliseconds;
    }

    state = SeekbarTime(
      currentPosition: Duration(milliseconds: newPosition),
      maxPosition: state.maxPosition,
      refreshCount: state.refreshCount + 1,
    );
    return;
  }

  FutureOr<SeekbarTime> _getNewSliderPosition() async {
    final dynamic currentPlaybackState = await ref.read(
      spotifyPlaybackStateProvider.future,
    );

    if (currentPlaybackState.statusCode == 204) {
      state = SeekbarTime(
        currentPosition: const Duration(milliseconds: 0),
        maxPosition: const Duration(milliseconds: 1),
      );
      return SeekbarTime(
        currentPosition: const Duration(milliseconds: 0),
        maxPosition: const Duration(milliseconds: 1),
      );
    }

    final SeekbarTime errorDuration = SeekbarTime(
      currentPosition: const Duration(milliseconds: 0),
      maxPosition: state.maxPosition,
    );

    try {
      final double newMaxPosition =
          (currentPlaybackState.body['item']['duration_ms'] as int).toDouble();
      final double newCurrentPosition =
          (currentPlaybackState.body['progress_ms'] as int).toDouble();
      const int refreshCount = 0;

      final bool isPlaying = currentPlaybackState.body['is_playing'];
      ref.read(seekbarPauseProvider.notifier).setValue(!isPlaying);
      ref.read(songLatencyProvider.notifier).stopStopwatch();
      final int latency = ref.read(songLatencyProvider).elapsed.inMilliseconds;

      final SeekbarTime newPositionInfo = SeekbarTime(
        currentPosition: Duration(
          milliseconds: newCurrentPosition.toInt() + latency,
        ),
        maxPosition: Duration(milliseconds: newMaxPosition.toInt()),
        refreshCount: refreshCount,
      );

      state = newPositionInfo;
      return Future.value(newPositionInfo);
    } on NoSuchMethodError {
      state = errorDuration;
      return errorDuration;

      // All other exceptions
    } on Exception {
      state = errorDuration;
      return errorDuration;
    }
  }
}

@Riverpod(keepAlive: true)
class SeekbarPause extends _$SeekbarPause {
  @override
  bool build() {
    return true;
  }

  void setValue(bool value) {
    state = value;
    return;
  }
}
