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
              return ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: ScrollablePositionedList.builder(
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
                ),
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
              DelayInfo(),
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

class DelayInfo extends ConsumerStatefulWidget {
  const DelayInfo({super.key});

  @override
  ConsumerState<DelayInfo> createState() => _DelayInfoState();
}

class _DelayInfoState extends ConsumerState<DelayInfo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(begin: Offset.zero, end: const Offset(0, 1))
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Cubic(0.2, 0.0, 0, 1.0),
          ),
        );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int delay = ref.watch(lyricDelayProvider);

    if (delay == 0) {
      _controller.forward();
    } else {
      _controller.reverse();
    }

    return SlideTransition(
      position: _offsetAnimation,
      child: Material(
        type: .button,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: .antiAlias,
        color: Colors.transparent,
        elevation: delay == 0 ? 0 : 6,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          constraints: const BoxConstraints(minWidth: 100),
          height: 40,
          alignment: Alignment.center,
          color: delay == 0
              ? Colors.black.withAlpha(0)
              : Theme.of(context).colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              '$delay ms',
              style: TextStyle(
                color: delay == 0
                    ? Colors.transparent
                    : Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
