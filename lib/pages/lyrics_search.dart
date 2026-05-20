import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotimmich/backend/lyric/lyric_api.dart';
import 'package:spotimmich/providers/lyrics_provider.dart';
import 'package:spotimmich/providers/spotify/song_info_provider.dart';

class LyricSearchPage extends ConsumerStatefulWidget {
  const LyricSearchPage({super.key});

  @override
  ConsumerState<LyricSearchPage> createState() => _LyricSearchState();
}

class _LyricSearchState extends ConsumerState<LyricSearchPage> {
  @override
  Widget build(BuildContext context) {
    final AsyncValue<Song> currentSong = ref.read(infoGetterProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Search lyrics')),
      body: currentSong.when(
        data: (Song song) {
          final Future<List<dynamic>> searchedResponse = ref.read(
            lyricSearchProvider(song.title, song.album!, song.artist).future,
          );

          return FutureBuilder(
            future: searchedResponse,
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                  final List<dynamic>? data = snapshot.data;

                  if (snapshot.hasData && data != null) {
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) =>
                          ListTile(title: Text(data[index]['name'])),
                    );
                  }

                  return Text('Loading');
                },
          );
        },
        error: (Object error, StackTrace stackTrace) => const Text('Error'),
        loading: () => const CircularProgressIndicator(),
      ),
    );
  }
}
