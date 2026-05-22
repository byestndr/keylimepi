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
    final AsyncValue<List<dynamic>> searchedResponse = ref.watch(
      lyricSearchProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search lyrics'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.filter_alt_sharp),
            ),
          ),
        ],
      ),
      body: searchedResponse.when(
        data: (List<dynamic> data) {
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              final double durationInSeconds = data[index]['duration'] ?? 0;
              final Duration duration = Duration(
                seconds: durationInSeconds.ceil(),
              );

              final int seconds = duration.inSeconds % 60;
              final int minutes = ((duration.inSeconds - (seconds)) / 60)
                  .toInt();

              final RegExp firstTimestampRegex = RegExp(
                r'\[(\d+):(\d{2}(?:\.\d+)?)\]',
              );
              final RegExpMatch? firstTimestamp = firstTimestampRegex
                  .firstMatch(data[index]['syncedLyrics'].toString());

              return ListTile(
                title: Text(data[index]['name']),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => SimpleDialog(
                      title: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Row(
                              mainAxisAlignment: .spaceBetween,
                              children: [
                                const Text('Lyrics'),
                                IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close))
                              ],
                            ),
                          ),
                          const Divider(),
                        ],
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Text(
                            data[index]['syncedLyrics'],
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                subtitle: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(data[index]['artistName']),
                    Text("Duration: $minutes:$seconds"),
                  ],
                ),
                trailing: Text('First lyric at: ${firstTimestamp!.group(0)}'),
              );
            },
          );
        },
        error: (Object error, StackTrace stackTrace) => const Text('Error'),
        loading: () => const CircularProgressIndicator(),
      ),
    );
  }
}
