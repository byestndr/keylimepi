import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotimmich/backend/lyric/lyric_api.dart';
import 'package:spotimmich/providers/lyrics_provider.dart';
import 'package:spotimmich/providers/spotify/song_info_provider.dart';
import 'package:spotimmich/providers/spotify/spotify_playbackstate.dart';

class LyricsPage extends ConsumerWidget {
  const LyricsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Map<String, dynamic>> lyrics = ref.watch(
      lyricsGetterProvider,
    );

    // Must be watched in order for the lyrics to update
    final AsyncValue<Song> currentSong = ref.watch(infoGetterProvider);

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
            data: (Map<String, dynamic> data) {
              final List<LyricLine> lyricsList = LyricLine.fromSyncedLyrics(data['syncedLyrics']);
              return Text(lyricsList[0].line);
            },
            error: (Object error, StackTrace stackTrace) => const Text('Error'),
            loading: () => const Text('Loading'),
          ),
        ],
      ),
    );
  }
}
