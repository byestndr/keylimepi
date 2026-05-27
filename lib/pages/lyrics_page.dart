import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:key_limepi/lyrics/widgets/delay_info.dart';
import 'package:key_limepi/lyrics/widgets/lyric_line.dart';
import 'package:key_limepi/pages/lyrics_search.dart';
import 'package:key_limepi/providers/lyrics/lyric_classes.dart';
import 'package:key_limepi/providers/lyrics/lyrics_provider.dart';
import 'package:key_limepi/providers/spotify/seekbar_provider.dart';
import 'package:key_limepi/providers/spotify/song_info_provider.dart';

class LyricsPage extends ConsumerStatefulWidget {
  const LyricsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LyricsPageState();
}

class _LyricsPageState extends ConsumerState<LyricsPage> {
  late ItemScrollController _listController;
  int currentLyricIndex = 0;
  bool _isScrolling = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _listController = ItemScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<LyricLine>> lyrics = ref.watch(lyricsGetterProvider);

    // DO NOT REMOVE: Must be watched in order for the lyrics to update
    ref.watch(infoGetterProvider);
    ref.watch(seekbarTimerProvider);
    ref.watch(lyricSyncProvider);

    ref.listen(currentLyricIndexProvider, (
      AsyncValue<int>? previous,
      AsyncValue<int> next,
    ) {
      next.whenData((int value) {
        if (_isScrolling) {
          return;
        }

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
            skipLoadingOnRefresh: false,
            skipLoadingOnReload: false,
            data: (List<LyricLine> data) {
              return ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: NotificationListener(
                  onNotification: (Notification notification) {
                    if (notification is ScrollUpdateNotification) {
                      setState(() {
                        _isScrolling = true;
                      });
                    } else if (notification is ScrollEndNotification) {
                      _timer?.cancel();

                      _timer = Timer(
                        const Duration(seconds: 3),
                        () => setState(() {
                          _isScrolling = false;
                        }),
                      );
                    }
                    return false;
                  },
                  child: ScrollablePositionedList.builder(
                    itemScrollController: _listController,
                    itemCount: data.length,
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height / 3,
                    ),
                    itemBuilder: (BuildContext context, int lineIndex) {
                      final bool isCurrentLyric =
                          lineIndex == currentLyricIndex;

                      return LyricLineWidget(
                        isCurrentLyric: isCurrentLyric,
                        lyric: data[lineIndex],
                      );
                    },
                  ),
                ),
              );
            },
            error: (Object error, StackTrace stackTrace) {
              return ListView(
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height / 3,
                ),
                children: [
                  LyricLineWidget(
                    isCurrentLyric: true,
                    lyric: LyricLine(
                      line: 'There was an error retrieving lyrics',
                      timestamp: const Duration(milliseconds: 0),
                    ),
                  ),
                ],
              );
            },
            loading: () {
              return Center(
                child: CircularProgressIndicator(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 10,
                  ),
                ),
              );
            },
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 15, right: 20),
          child: DelayControls(),
        ),
        Align(
          alignment: .topRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 15, right: 20),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => const LyricSearchPage(),
                  ),
                );
              },
              icon: const Icon(Icons.search),
              tooltip: 'Search',
            ),
          ),
        ),
      ],
    );
  }
}

