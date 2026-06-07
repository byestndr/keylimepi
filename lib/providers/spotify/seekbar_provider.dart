import 'dart:async';

import 'package:chopper/src/response.dart';
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
    _timer = Timer.periodic(const Duration(milliseconds: 200), (Timer timer) {
      ref.invalidate(getNewSeekbarPositionProvider);
      ref.read(seekbarPositionProvider.notifier).updateSliderPosition();
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }
}

@riverpod
class GetNewSeekbarPosition extends _$GetNewSeekbarPosition {
  @override
  FutureOr<void> build() async {
    ref.watch(spotifyPlaybackStateProvider);

    if (!(await _isNewState())) {
      return;
    }

    _getNewSliderPosition();
    return;
  }

  Future<bool> _isNewState() async {
    final bool isPaused = await ref.read(seekbarPauseProvider.future);
    final SeekbarTime currentPosition = ref.read(seekbarPositionProvider);

    return currentPosition.currentPosition.inMilliseconds == 0 ||
        isPaused ||
        currentPosition.refreshCount == 25;
  }

  FutureOr<void> _getNewSliderPosition() async {
    final dynamic currentPlaybackState = await ref.read(
      spotifyPlaybackStateProvider.future,
    );

    if (currentPlaybackState.statusCode == 204) {
      final SeekbarTime errorDuration = SeekbarTime(
        currentPosition: const Duration(milliseconds: 0),
        maxPosition: const Duration(milliseconds: 1),
      );

      ref
          .read(seekbarPositionProvider.notifier)
          .overrideSliderPostition(errorDuration);
    }

    final SeekbarTime existingErrorDuration = SeekbarTime(
      currentPosition: const Duration(milliseconds: 0),
      maxPosition: ref.read(seekbarPositionProvider).maxPosition,
    );

    try {
      // Get current information
      final double newMaxPosition =
          (currentPlaybackState.body['item']['duration_ms'] as int).toDouble();
      final double newCurrentPosition =
          (currentPlaybackState.body['progress_ms'] as int).toDouble();
      const int refreshCount = 0;

      // Stop latency stopwatch for use in adding latency offset
      ref.read(songLatencyProvider.notifier).stopStopwatch();
      final int latency = ref.read(songLatencyProvider).elapsed.inMilliseconds;

      // Final position info
      final SeekbarTime newPositionInfo = SeekbarTime(
        currentPosition: Duration(
          milliseconds: newCurrentPosition.toInt() + latency,
        ),
        maxPosition: Duration(milliseconds: newMaxPosition.toInt()),
        refreshCount: refreshCount,
      );

      ref
          .read(seekbarPositionProvider.notifier)
          .overrideSliderPostition(newPositionInfo);
    } on Error {
      ref
          .read(seekbarPositionProvider.notifier)
          .overrideSliderPostition(existingErrorDuration);
    } on Exception {
      ref
          .read(seekbarPositionProvider.notifier)
          .overrideSliderPostition(existingErrorDuration);
    }

    return;
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
    final bool isPaused = await ref.read(seekbarPauseProvider.future);

    if (isPaused) {
      return;
    }

    _incrementSliderPosition();

    // If it's the end of the song, we pull the new
    // playback state to get the new song.
    if (state.currentPosition == state.maxPosition) {
      ref.invalidate(spotifyPlaybackStateProvider);
    }

    return;
  }

  void overrideSliderPostition(SeekbarTime newPosition) {
    state = newPosition;
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
}

@riverpod
Future<bool> seekbarPause(Ref ref) async {
  final Response<dynamic> currentPlaybackState = await ref.watch(
    spotifyPlaybackStateProvider.future,
  );
  late bool isPlaying;
  try {
    isPlaying = currentPlaybackState.body['is_playing'];
  } on TypeError {
    isPlaying = true;
  }
  return !isPlaying;
}
