import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotimmich/providers/lyrics_provider.dart';

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
    final SearchFilter filterSettings = ref.watch(lyricSearchFilterProvider);

    // Watch this to keep the current filter state on dialog exit
    // and clear it when the page is exited
    ref.watch(lyricSearchFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search lyrics'),

        actions: [
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
                children: [
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
            children: [
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

class LyricTile extends ConsumerWidget {
  final dynamic lyric;
  final int minutes;
  final int seconds;
  final RegExpMatch? firstTimestamp;
  const LyricTile({
    super.key,
    required this.minutes,
    required this.seconds,
    required this.firstTimestamp,
    required this.lyric,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text('${lyric['name']} - ${lyric['artistName']}'),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              ShowLyricDialog(lyrics: lyric['syncedLyrics']),
        );
      },
      subtitle: Column(
        crossAxisAlignment: .start,
        children: [
          Text("Duration: $minutes:$seconds"),
          Text('First lyric at: ${firstTimestamp!.group(0)}'),
        ],
      ),
      trailing: IconButton(
        onPressed: () {
          ref
              .read(lyricsGetterProvider.notifier)
              .overrideLyrics(lyric['syncedLyrics']);
          Navigator.of(context).pop();
        },
        icon: const Icon(Icons.arrow_right),
      ),
    );
  }
}

class ShowLyricDialog extends StatelessWidget {
  final String lyrics;
  const ShowLyricDialog({super.key, required this.lyrics});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Column(
        crossAxisAlignment: .start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                const Text('Lyrics'),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          const Divider(),
        ],
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Text(lyrics, softWrap: true),
        ),
      ],
    );
  }
}

class LyricSearchFilterDialog extends ConsumerWidget {
  const LyricSearchFilterDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SearchFilter toggleStates = ref.watch(lyricSearchFilterProvider);

    return SimpleDialog(
      title: Column(
        crossAxisAlignment: .start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                const Text('Filter by...'),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          const Divider(),
        ],
      ),
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Column(
            children: [
              ListTile(
                title: const Text('Album'),
                trailing: Switch(
                  value: toggleStates.album,
                  onChanged: (bool value) => ref
                      .read(lyricSearchFilterProvider.notifier)
                      .changeFilterSettings(album: value),
                ),
              ),
              ListTile(
                title: const Text('Artist'),
                trailing: Switch(
                  value: toggleStates.artist,
                  onChanged: (bool value) => ref
                      .read(lyricSearchFilterProvider.notifier)
                      .changeFilterSettings(artist: value),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
