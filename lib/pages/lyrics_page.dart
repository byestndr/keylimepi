import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotimmich/providers/lyrics_provider.dart';
import 'package:spotimmich/providers/spotify/song_info_provider.dart';

class LyricsPage extends ConsumerWidget {
  const LyricsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<LyricLine>> lyrics = ref.watch(lyricsGetterProvider);

    // Must be watched in order for the lyrics to update
    final AsyncValue<Song> currentSong = ref.watch(infoGetterProvider);
    final currentLine = ref.watch(currentLyricProvider);

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
            data: (List<LyricLine> data) {
              return Text(data[0].line);
            },
            error: (Object error, StackTrace stackTrace) {
              print(error.toString());
              return Text('Error');
            },
            loading: () => const Text('Loading'),
          ),
        ],
      ),
    );
  }
}
