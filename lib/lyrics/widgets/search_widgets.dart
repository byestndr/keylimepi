import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotimmich/providers/lyrics/lyrics_provider.dart';
import 'package:spotimmich/providers/lyrics/search_provider.dart';

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
    late String newSeconds;
    if (seconds.toString().length == 1) {
      newSeconds = '0$seconds';
    } else {
      newSeconds = seconds.toString();
    }

    return ListTile(
      title: Text(
        '${lyric['name']} - ${lyric['artistName']}',
        style: const TextStyle(fontFamilyFallback: <String>['NotoSansJP']),
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              ShowLyricDialog(lyrics: lyric['syncedLyrics']),
        );
      },
      subtitle: Column(
        crossAxisAlignment: .start,
        children: <Widget>[
          Text("Duration: $minutes:$newSeconds"),
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
        tooltip: 'Use as current lyric',
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
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Row(
              mainAxisAlignment: .spaceBetween,
              children: <Widget>[
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
      children: <Widget>[
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
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Row(
              mainAxisAlignment: .spaceBetween,
              children: <Widget>[
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
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Column(
            children: <Widget>[
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
