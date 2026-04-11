import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotimmich/backend/spotify/spotify_api-chopper.dart';
import 'package:spotimmich/providers/spotify/song_info_provider.dart';
import 'package:spotimmich/backend/spotify/spotifyapi.dart';
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
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
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
      data: (dynamic data) {
        setState(() {
          _currentState = data.body['repeat_state'];
          _currentIcon = RepeatStates.getIcon(_currentState);
        });
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
      onPressed: () {
        final RepeatStates _repeatState = RepeatStates.getStateFromString(
          _currentState,
        );
        setState(() {
          _currentState = _repeatState.next;
          _currentIcon = _repeatState.nextIcon;
        });
        final SpotifyUserService spotifyAPI = SpotifyUserService.create();
        spotifyAPI.cycleRepeat(_currentState);
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

class NextButton extends StatelessWidget {
  const NextButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      onPressed: () {
        final SpotifyUserService spotifyAPI = SpotifyUserService.create();
        spotifyAPI.skipForward();
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

class PreviousButton extends StatelessWidget {
  const PreviousButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      onPressed: () {
        final SpotifyUserService spotifyAPI = SpotifyUserService.create();
        spotifyAPI.skipPrevious();
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

class ShuffleButton extends ConsumerWidget {
  const ShuffleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<dynamic> playbackStateResponse = ref.watch(
      spotifyPlaybackstateProvider,
    );

    return IconButton.filled(
      onPressed: () {
        Interactions().shuffleToggle();
      },
      icon: Icon(
        playbackStateResponse.when(
          skipLoadingOnRefresh: true,
          skipLoadingOnReload: true,
          data: (dynamic data) {
            if (data.statusCode == 204) {
              return Icons.shuffle;
            }

            return data.body['shuffle_state'] == false
                ? Icons.shuffle
                : Icons.shuffle_on_rounded;
          },
          error: (Object error, StackTrace stack) {
            return Icons.shuffle;
          },
          loading: () {
            return Icons.shuffle;
          },
        ),
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

class PauseButton extends ConsumerWidget {
  const PauseButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<dynamic> playbackStateResponse = ref.watch(
      spotifyPlaybackstateProvider,
    );

    return FloatingActionButton(
      onPressed: () {
        final SpotifyUserService spotifyAPI = SpotifyUserService.create();
        spotifyAPI.playPause();
      },
      child: Icon(
        playbackStateResponse.when(
          skipLoadingOnRefresh: true,
          skipLoadingOnReload: true,
          data: (dynamic data) {
            if (data.statusCode == 204) {
              return Icons.play_arrow;
            }

            return data.body['is_playing'] == false
                ? Icons.play_arrow
                : Icons.pause;
          },
          error: (Object error, StackTrace stack) {
            return Icons.play_arrow;
          },
          loading: () {
            return Icons.play_arrow;
          },
        ),
      ),
    );
  }
}
