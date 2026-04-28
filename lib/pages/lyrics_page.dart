import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotimmich/backend/lyric/lyric_api.dart';
import 'package:spotimmich/providers/lyrics_provider.dart';

class LyricsPage extends ConsumerWidget {
  const LyricsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Map<String, dynamic>> lyrics = ref.watch(lyricsGetterProvider);

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
        ],
      ),
    );
  }
}
