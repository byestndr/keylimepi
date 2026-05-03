import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spotimmich/providers/spotify/spotify_playbackstate.dart';

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

    if (state.currentPosition.inMilliseconds == 0 ||
        isPaused ||
        state.refreshCount == 25) {
      await _getNewSliderPosition();
    }

    if (isPaused) {
      return;
    }

    if (state.refreshCount < 25) {
      _incrementSliderPosition();
      return;
    }

    return;
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

  FutureOr<void> _getNewSliderPosition() async {
    final dynamic currentPlaybackState = await ref.read(
      spotifyPlaybackStateProvider.future,
    );

    if (currentPlaybackState.statusCode == 204) {
      state = SeekbarTime(
        currentPosition: const Duration(milliseconds: 0),
        maxPosition: const Duration(milliseconds: 1),
      );
      return;
    }

    try {
      final double newMaxPosition =
          (currentPlaybackState.body['item']['duration_ms'] as int).toDouble();
      final double newCurrentPosition =
          (currentPlaybackState.body['progress_ms'] as int).toDouble();
      const int refreshCount = 0;

      final bool isPlaying = currentPlaybackState.body['is_playing'];
      ref.read(seekbarPauseProvider.notifier).setValue(!isPlaying);

      state = SeekbarTime(
        currentPosition: Duration(milliseconds: newCurrentPosition.toInt()),
        maxPosition: Duration(milliseconds: newMaxPosition.toInt()),
        refreshCount: refreshCount,
      );
      return;
    } on NoSuchMethodError {
      state = SeekbarTime(
        currentPosition: const Duration(milliseconds: 0),
        maxPosition: state.maxPosition,
      );
      return;

      // All other exceptions
    } on Exception {
      state = SeekbarTime(
        currentPosition: const Duration(milliseconds: 0),
        maxPosition: state.maxPosition,
      );
      return;
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
