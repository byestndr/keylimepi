import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:spotimmich/providers/lyrics_provider.dart';
import 'package:spotimmich/providers/spotify/seekbar_provider.dart';
import 'package:spotimmich/providers/spotify/song_info_provider.dart';

class LyricsPage extends ConsumerStatefulWidget {
  const LyricsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LyricsPageState();
}

class _LyricsPageState extends ConsumerState<LyricsPage> {
  late ItemScrollController _listController;
  int currentLyricIndex = 0;

  @override
  void initState() {
    super.initState();
    _listController = ItemScrollController();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<LyricLine>> lyrics = ref.watch(lyricsGetterProvider);

    // DO NOT REMOVE: Must be watched in order for the lyrics to update
    // ignore: unused_local_variable
    final AsyncValue<Song> currentSong = ref.watch(infoGetterProvider);
    ref.watch(seekbarTimerProvider);
    ref.watch(lyricSyncProvider);

    final int delay = ref.watch(lyricDelayProvider);

    ref.listen(currentLyricIndexProvider, (
      AsyncValue<int>? previous,
      AsyncValue<int> next,
    ) {
      next.whenData((int value) {
        if (mounted) {
          setState(() {
            currentLyricIndex = value;
          });
        }

        _listController.scrollTo(
          index: value,
          duration: const Duration(milliseconds: 150),
          curve: Curves.decelerate,
          alignment: .5,
        );
      });
    });

    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 70),
          child: lyrics.when(
            data: (List<LyricLine> data) {
              return ScrollablePositionedList.builder(
                itemScrollController: _listController,
                itemCount: data.length,
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height / 3,
                ),
                itemBuilder: (BuildContext context, int lineIndex) {
                  final bool isCurrentLyric = lineIndex == currentLyricIndex;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: AnimatedDefaultTextStyle(
                      style: TextStyle(
                        fontSize: isCurrentLyric ? 34 : 30,
                        fontFamilyFallback: <String>['NotoSansJP'],
                        fontFamily: 'RobotoFlexVariable',
                        fontVariations: [
                          isCurrentLyric
                              ? const FontVariation.width(130)
                              : const FontVariation.width(120),
                          isCurrentLyric
                              ? const FontVariation.weight(850)
                              : const FontVariation.weight(600),
                        ],
                      ),
                      duration: const Duration(milliseconds: 150),
                      curve: Curves.easeOut,
                      child: Text(data[lineIndex].line),
                    ),
                  );
                },
              );
            },
            error: (Object error, StackTrace stackTrace) => const Text('Error'),
            loading: () {
              return const Text('Loading');
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 15, right: 20),
          child: Row(
            spacing: 5,
            crossAxisAlignment: .end,
            mainAxisAlignment: .end,
            children: <Widget>[
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
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: .end,
                spacing: 5,
                crossAxisAlignment: .end,
                children: <Widget>[
                  FloatingActionButton.small(
                    onPressed: () {
                      ref.read(lyricDelayProvider.notifier).increaseDelay(100);
                    },
                    child: const Icon(Icons.arrow_upward_rounded),
                  ),
                  FloatingActionButton.small(
                    onPressed: () {
                      ref.read(lyricDelayProvider.notifier).decreaseDelay(100);
                    },
                    child: const Icon(Icons.arrow_downward_rounded),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
