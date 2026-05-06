import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotimmich/providers/lyrics_provider.dart';
import 'package:spotimmich/providers/spotify/seekbar_provider.dart';
import 'package:spotimmich/providers/spotify/song_info_provider.dart';

class LyricsPage extends ConsumerWidget {
  const LyricsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<LyricLine>> lyrics = ref.watch(lyricsGetterProvider);

    // Must be watched in order for the lyrics to update
    final AsyncValue<Song> currentSong = ref.watch(infoGetterProvider);
    final AsyncValue<int> currentLineIndex = ref.watch(
      currentLyricIndexProvider,
    );
    ref.watch(seekbarTimerProvider);
    ref.watch(lyricSyncProvider);
    final int delay = ref.watch(lyricDelayProvider);

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          lyrics.when(
            data: (List<LyricLine> lyricList) {
              return Text(
                currentLineIndex.when(
                  skipLoadingOnRefresh: true,
                  skipLoadingOnReload: true,
                  skipError: true,
                  data: (int index) => lyricList[index].line,
                  error: (Object error, StackTrace stackTrace) => 'Error',
                  loading: () => 'Loading',
                ),
              );
            },
            error: (Object error, StackTrace stackTrace) {
              return const Text('Error');
            },
            loading: () => const Text('Loading'),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15, right: 20),
            child: Row(
              spacing: 5,
              crossAxisAlignment: .end,
              mainAxisAlignment: .end,
              children: [
                Material(
                  type: .card,
                  borderRadius: BorderRadius.circular(12),
                  clipBehavior: .antiAlias,
                  elevation: 6,
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 100),
                    height: 40,
                    color: Theme.of(context).colorScheme.primaryContainer,
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        '$delay ms',
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: .end,
                  spacing: 5,
                  crossAxisAlignment: .end,
                  children: [
                    FloatingActionButton.small(
                      onPressed: () {
                        ref
                            .read(lyricDelayProvider.notifier)
                            .increaseDelay(100);
                      },
                      child: const Icon(Icons.arrow_upward_rounded),
                    ),
                    FloatingActionButton.small(
                      onPressed: () {
                        ref
                            .read(lyricDelayProvider.notifier)
                            .decreaseDelay(100);
                      },
                      child: const Icon(Icons.arrow_downward_rounded),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
