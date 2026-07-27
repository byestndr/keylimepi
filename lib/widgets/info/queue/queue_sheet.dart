import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:key_limepi/providers/spotify/queue_provider.dart';
import 'package:key_limepi/providers/spotify/song_info_provider.dart';
import 'package:key_limepi/song_select/song_select_item.dart';
import 'package:key_limepi/widgets/info/queue/queue_components.dart';
import 'package:key_limepi/widgets/info/queue/queue_headers.dart';

class BottomSheetQueue extends ConsumerStatefulWidget {
  const BottomSheetQueue({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BottomSheetQueueState();
}

class _BottomSheetQueueState extends ConsumerState<BottomSheetQueue> {
  final GlobalKey<SliverAnimatedListState> _animatedListKey =
      GlobalKey<SliverAnimatedListState>();
  List<SpotifyQueueItem>? _currentSongQueue;

  void _diffSongQueue(List<SpotifyQueueItem> newQueue) {
    Set<SpotifyQueueItem> newQueueAsSet = newQueue.toSet();
    final Set<SpotifyQueueItem> currentQueueAsSet =
        _currentSongQueue?.toSet() ?? <SpotifyQueueItem>{};

    final Set<SpotifyQueueItem> removedSongs = currentQueueAsSet.difference(
      newQueueAsSet,
    );
    final Set<SpotifyQueueItem> newSongs = newQueueAsSet.difference(
      currentQueueAsSet,
    );

    final SliverAnimatedListState? animatedListState =
        _animatedListKey.currentState;

    if (!mounted) return;

    for (final SpotifyQueueItem songToRemove in removedSongs) {
      if (animatedListState == null) {
        return;
      }

      final int itemIndex = _currentSongQueue!.indexOf(songToRemove);
      _currentSongQueue!.removeAt(itemIndex);

      animatedListState.removeItem(itemIndex, (
        BuildContext context,
        Animation<double> animation,
      ) {
        final Animation<Offset> slideAnimation =
            Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(
              CurvedAnimation(
                parent: animation,
                curve: const Cubic(0.3, 0.0, 0.8, 0.15),
              ),
            );
        return QueueItemAnimated(
          slideAnimation: slideAnimation,
          sizeAnimation: animation,
          song: songToRemove,
          index: songToRemove.queuePosition,
        );
      });
    }

    for (final SpotifyQueueItem songToAdd in newSongs) {
      if (animatedListState != null) {
        _currentSongQueue!.insert(songToAdd.queuePosition, songToAdd);
        animatedListState.insertItem(songToAdd.queuePosition);
      }
    }

    return;
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<SpotifyQueueItem>> queue = ref.watch(
      spotifyQueueProvider,
    );
    final AsyncValue<SpotifySong?> currentSong = ref.watch(infoGetterProvider);
    return DraggableScrollableSheet(
      snap: true,
      expand: false,
      initialChildSize: 0.5,
      minChildSize: 0.25,
      maxChildSize: 1,
      builder: (BuildContext context, ScrollController scrollController) {
        return CustomScrollView(
          controller: scrollController,
          slivers: <Widget>[
            SliverPersistentHeader(
              delegate: QueueHeader(),
              pinned: true,
              floating: true,
            ),

            currentSong.when(
              skipLoadingOnRefresh: true,
              skipLoadingOnReload: true,
              skipError: true,
              data: (SpotifySong? data) {
                if (data?.image.toString() == null || data == null) {
                  return SliverToBoxAdapter(child: Container());
                }

                return SliverPersistentHeader(
                  delegate: CurrentQueueSong(data: data),
                  pinned: true,
                );
              },
              loading: () => Container(),
              error: (Object error, StackTrace stackTrace) => Container(),
            ),

            queue.when(
              skipLoadingOnRefresh: true,
              skipLoadingOnReload: true,
              skipError: true,
              data: (List<SpotifyQueueItem> data) {
                _currentSongQueue ??= data;

                if (_currentSongQueue != null) {
                  _diffSongQueue(data);
                }

                if (_currentSongQueue!.isEmpty) {
                  return const QueueEmpty();
                }

                return SliverAnimatedList(
                  key: _animatedListKey,
                  initialItemCount: data.length,
                  itemBuilder:
                      (
                        BuildContext context,
                        int index,
                        Animation<double> animation,
                      ) {
                        final Animation<Offset> slideAnimation =
                            Tween<Offset>(
                              begin: const Offset(1, 0),
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                parent: animation,
                                curve: const Cubic(0.05, 0.7, 0.1, 1.0),
                              ),
                            );

                        return QueueItemAnimated(
                          slideAnimation: slideAnimation,
                          sizeAnimation: animation,
                          song: _currentSongQueue![index],
                          index: index,
                        );
                      },
                );
              },
              error: (Object error, StackTrace stackTrace) {
                return const QueueError();
              },
              loading: () {
                return const SliverList(
                  delegate: SliverChildListDelegate.fixed(<Widget>[
                    LinearProgressIndicator(minHeight: 2),
                  ]),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

void showQueueSheet(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (BuildContext context) => const BottomSheetQueue(),
  );
}
