import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotimmich/providers/song_info_provider.dart';
import 'package:spotimmich/backend/spotify/spotifyapi.dart';

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

class RepeatButton extends ConsumerWidget {
  const RepeatButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<dynamic> playbackStateResponse = ref.watch(
      getPlaybackStateProvider,
    );

    return IconButton.filled(
      onPressed: () {
        Interactions().repeatState();
      },
      icon: Icon(
        playbackStateResponse.when(
          skipLoadingOnRefresh: true,
          skipLoadingOnReload: true,
          data: (dynamic data) {
            final String? iconState = data['repeat_state'];

            if (iconState == null) {
              return Icons.repeat;
            }

            final IconData currentIcon = RepeatStates.getIcon(
              iconState
            );
            return currentIcon;
          },
          error: (Object error, StackTrace stack) {
            return Icons.repeat;
          },
          loading: () {
            return Icons.repeat;
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

class NextButton extends StatelessWidget {
  const NextButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
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
    );
  }
}

class PreviousButton extends StatelessWidget {
  const PreviousButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
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
      getPlaybackStateProvider,
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
            return data['shuffle_state'] == false
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
      getPlaybackStateProvider,
    );

    return FloatingActionButton(
      onPressed: () {
        Interactions().pauseToggle();
      },
      child: Icon(
        playbackStateResponse.when(
          skipLoadingOnRefresh: true,
          skipLoadingOnReload: true,
          data: (dynamic data) {
            return data['is_playing'] == false ? Icons.play_arrow : Icons.pause;
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
