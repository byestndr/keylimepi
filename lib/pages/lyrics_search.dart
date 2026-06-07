import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:key_limepi/lyrics/widgets/search_widgets.dart';
import 'package:key_limepi/lyrics/providers/search_provider.dart';

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

    // Watch this to keep the current filter state on dialog exit
    // and clear it when the page is exited
    ref.watch(lyricSearchFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search lyrics'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      const LyricSearchFilterDialog(),
                );
              },
              icon: const Icon(Icons.filter_alt_sharp),
              tooltip: 'Filter',
            ),
          ),
        ],
      ),
      body: searchedResponse.when(
        skipLoadingOnRefresh: false,
        skipError: true,
        skipLoadingOnReload: false,
        data: (List<dynamic> data) {
          if (data.isEmpty) {
            return const Center(
              child: Column(
                crossAxisAlignment: .center,
                mainAxisAlignment: .center,
                children: <Widget>[
                  Text(
                    '(⁠｡⁠ŏ⁠﹏⁠ŏ⁠)',
                    style: TextStyle(
                      fontSize: 48,
                      color: Colors.grey,
                      fontFamily: 'NotoSansJP',
                      fontWeight: .w900,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(
                      'Sorry, but we couldn\'t find any matching lyrics. Have you tried using filters?',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: .center,
                    ),
                  ),
                ],
              ),
            );
          }

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

              return LyricTile(
                minutes: minutes,
                seconds: seconds,
                firstTimestamp: firstTimestamp,
                lyric: data[index],
              );
            },
          );
        },
        error: (Object error, StackTrace stackTrace) => const Center(
          child: Column(
            crossAxisAlignment: .center,
            mainAxisAlignment: .center,
            children: <Widget>[
              Text(
                '(⁠┛⁠◉⁠Д⁠◉⁠)⁠┛⁠彡⁠┻⁠━⁠┻',
                style: TextStyle(fontSize: 48, color: Colors.grey),
              ),
              Text(
                'There was an error loading lyrics.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

