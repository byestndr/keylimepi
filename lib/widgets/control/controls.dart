import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotimmich/backend/spotify/spotify_api.dart';
import 'package:spotimmich/providers/spotify/song_info_provider.dart';
import 'package:spotimmich/providers/spotify/spotify_playbackstate.dart';

const double iconButtonDensityHorizontal = 1;
const double iconButtonDensityVertical = 1;

enum RepeatStates {
  off('off', Icons.repeat_rounded, 'context', Icons.repeat_on_rounded),
  context(
    'context',
    Icons.repeat_on_rounded,
    'track',
    Icons.repeat_one_on_rounded,
  ),
  track('track', Icons.repeat_one_on_rounded, 'off', Icons.repeat);

  final String current;
  final String next;
  final IconData nextIcon;
  final IconData currentIcon;

  const RepeatStates(this.current, this.currentIcon, this.next, this.nextIcon);

  static IconData getIcon(String currentState) {
    for (final RepeatStates state in values) {
      if (state.current == currentState) {
        return state.currentIcon;
      }
    }
    return Icons.repeat;
  }

  static RepeatStates getStateFromString(String currentState) {
    for (final RepeatStates states in values) {
      if (states.current == currentState) {
        return states;
      }
    }
    return RepeatStates.off;
  }
}

class PlaybackControls extends StatelessWidget {
  const PlaybackControls({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        PauseButton(),
        PreviousButton(),
        NextButton(),
        RepeatButton(),
        ShuffleButton(),
        QueueButton(),
      ],
    );
  }
}

class RepeatButton extends ConsumerStatefulWidget {
  const RepeatButton({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RepeatButtonState();
}

class _RepeatButtonState extends ConsumerState<RepeatButton> {
  late Timer _timer;
  String _currentState = 'off';
  IconData _currentIcon = Icons.repeat_rounded;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      _getCurrentState();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  void _getCurrentState() {
    final AsyncValue<dynamic> playbackStateResponse = ref.read(
      spotifyPlaybackstateProvider,
    );

    playbackStateResponse.when(
      skipError: true,
      skipLoadingOnRefresh: true,
      skipLoadingOnReload: true,
      data: (dynamic data) {
        try {
          setState(() {
            _currentState = data.body['repeat_state'];
            _currentIcon = RepeatStates.getIcon(_currentState);
          });
        } on Error {
          _currentState = 'off';
          _currentIcon = Icons.repeat_rounded;
        }
      },
      error: (Object error, StackTrace stackTrace) => setState(() {
        _currentIcon = Icons.repeat_rounded;
      }),
      loading: () => setState(() {
        _currentIcon = Icons.repeat_rounded;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      onPressed: () async {
        final RepeatStates _repeatState = RepeatStates.getStateFromString(
          _currentState,
        );
        setState(() {
          _currentState = _repeatState.next;
          _currentIcon = _repeatState.nextIcon;
        });
        final SpotifyUserService spotifyAPI = SpotifyUserService.create();
        await spotifyAPI.cycleRepeat(_currentState);
        ref.invalidate(spotifyPlaybackstateProvider);
      },
      icon: Icon(_currentIcon),
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
    );
  }
}

class NextButton extends ConsumerWidget {
  const NextButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton.filled(
      onPressed: () async {
        final SpotifyUserService spotifyAPI = SpotifyUserService.create();
        await spotifyAPI.skipForward();
        ref.invalidate(spotifyPlaybackstateProvider);
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
    );
  }
}

class PreviousButton extends ConsumerWidget {
  const PreviousButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton.filled(
      onPressed: () async {
        final SpotifyUserService spotifyAPI = SpotifyUserService.create();
        await spotifyAPI.skipPrevious();
        ref.invalidate(spotifyPlaybackstateProvider);
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
    );
  }
}

class QueueButton extends ConsumerWidget {
  const QueueButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton.filled(
      onPressed: () {
        ref.read(isQueueExpandedProvider.notifier).changeState();
      },
      icon: const Icon(Icons.queue_music_rounded),
      iconSize: 30,
      visualDensity: const VisualDensity(horizontal: 1, vertical: 1),
      style: IconButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(16),
        ),
      ),
    );
  }
}

class ShuffleButton extends ConsumerStatefulWidget {
  const ShuffleButton({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShuffleButtonState();
}

class _ShuffleButtonState extends ConsumerState<ShuffleButton> {
  late Timer _timer;
  bool _currentState = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      _getCurrentState();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  void _getCurrentState() {
    final AsyncValue<dynamic> playbackStateResponse = ref.read(
      spotifyPlaybackstateProvider,
    );
    playbackStateResponse.when(
      skipError: true,
      skipLoadingOnRefresh: true,
      skipLoadingOnReload: true,
      data: (dynamic data) {
        try {
          setState(() {
            _currentState = data.body['shuffle_state'];
          });
        } on Error {
          _currentState = false;
        }
      },
      error: (Object error, StackTrace stackTrace) => setState(() {
        _currentState = false;
      }),
      loading: () => setState(() {
        _currentState = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      onPressed: () async {
        setState(() {
          _currentState = !_currentState;
        });
        final SpotifyUserService spotifyAPI = SpotifyUserService.create();
        await spotifyAPI.shuffleToggle(_currentState);
        ref.invalidate(spotifyPlaybackstateProvider);
      },
      icon: Icon(
        _currentState ? Icons.shuffle_on_rounded : Icons.shuffle_rounded,
      ),
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
    );
  }
}

class PauseButton extends ConsumerStatefulWidget {
  const PauseButton({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PauseButtonState();
}

class _PauseButtonState extends ConsumerState<PauseButton>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  bool _currentState = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      _getCurrentState();
    });
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
    _controller.dispose();
  }

  void _getCurrentState() {
    final AsyncValue<dynamic> playbackStateResponse = ref.read(
      spotifyPlaybackstateProvider,
    );
    playbackStateResponse.when(
      skipError: true,
      skipLoadingOnRefresh: true,
      skipLoadingOnReload: true,
      data: (dynamic data) {
        try {
          setState(() {
            _currentState = data.body['is_playing'];
          });
        } on Error {
          _currentState = false;
        }

        if (_currentState) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      },
      error: (Object error, StackTrace stackTrace) => setState(() {
        _currentState = false;
      }),
      loading: () => setState(() {
        _currentState = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        _currentState = !_currentState;
        if (_currentState) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
        final SpotifyUserService spotifyAPI = SpotifyUserService.create();
        await spotifyAPI.playPause();
        ref.invalidate(spotifyPlaybackstateProvider);
      },
      child: AnimatedIcon(icon: AnimatedIcons.play_pause, progress: _animation),
    );
  }
}
