import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotimmich/backend/spotify/spotify_api.dart';
import 'package:spotimmich/providers/spotify/queue_provider.dart';
import 'package:spotimmich/providers/spotify/song_info_provider.dart';
import 'package:spotimmich/providers/spotify/spotify_playbackstate.dart';

class QueueHeader extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: const Column(
        crossAxisAlignment: .start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 10.0, bottom: 10.0),
            child: Text(
              'Queue',
              style: TextStyle(fontSize: 22, fontWeight: .w500),
            ),
          ),
          Divider(thickness: 0, height: 1),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 42;

  @override
  double get minExtent => 42;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class CurrentQueueSong extends SliverPersistentHeaderDelegate {
  final Song data;
  const CurrentQueueSong({required this.data});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Column(
        children: [
          QueueItem(song: data, index: 0, isTappable: false),
          const Divider(thickness: 0, height: 1),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 58;

  @override
  double get minExtent => 58;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class BottomSheetQueue extends ConsumerStatefulWidget {
  const BottomSheetQueue({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BottomSheetQueueState();
}

class _BottomSheetQueueState extends ConsumerState<BottomSheetQueue> {
  final GlobalKey<SliverAnimatedListState> _animatedListKey =
      GlobalKey<SliverAnimatedListState>();
  List<Song>? _currentSongQueue;

  void _diffSongQueue(List<Song> newQueue) {
    Set<Song> newQueueAsSet = newQueue.toSet();
    final Set<Song> currentQueueAsSet = _currentSongQueue?.toSet() ?? <Song>{};

    final Set<Song> removedSongs = currentQueueAsSet.difference(newQueueAsSet);
    final Set<Song> newSongs = newQueueAsSet.difference(currentQueueAsSet);

    final SliverAnimatedListState? animatedListState =
        _animatedListKey.currentState;

    if (!mounted) return;

    for (final Song songToRemove in removedSongs) {
      if (animatedListState != null) {
        final int itemIndex = _currentSongQueue!.indexOf(songToRemove);
        _currentSongQueue!.removeAt(itemIndex);

        animatedListState.removeItem(itemIndex, (
          BuildContext context,
          Animation<double> animation,
        ) {
          final Animation<Offset> slideAnimation =
              Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: const Cubic(0.3, 0.0, 0.8, 0.15),
                ),
              );
          return QueueItemAnimated(
            slideAnimation: slideAnimation,
            sizeAnimation: animation,
            song: songToRemove,
            index: songToRemove.queuePosition!,
          );
        });
      }
    }

    for (final Song songToAdd in newSongs) {
      if (animatedListState != null) {
        _currentSongQueue!.insert(songToAdd.queuePosition!, songToAdd);
        animatedListState.insertItem(songToAdd.queuePosition!);
      }
    }

    return;
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<Song>> queue = ref.watch(spotifyQueueProvider);
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
            Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                final AsyncValue<Song> currentSong = ref.watch(
                  infoGetterProvider,
                );

                return currentSong.when(
                  skipLoadingOnRefresh: true,
                  skipLoadingOnReload: true,
                  skipError: true,
                  data: (Song data) {
                    if (data.image == null) {
                      return SliverToBoxAdapter(child: Container());
                    }

                    return SliverPersistentHeader(
                      delegate: CurrentQueueSong(data: data),
                      pinned: true,
                    );
                  },
                  loading: () => Container(),
                  error: (Object error, StackTrace stackTrace) => Container(),
                );
              },
            ),
            queue.when(
              skipLoadingOnRefresh: true,
              skipLoadingOnReload: true,
              skipError: true,
              data: (List<Song> data) {
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
                return const QueueEmpty();
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

class QueueError extends StatelessWidget {
  const QueueError({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverList(
      delegate: SliverChildListDelegate.fixed(<Widget>[
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: .center,
            mainAxisAlignment: .center,
            children: <Widget>[
              Text(
                '(⁠┛⁠◉⁠Д⁠◉⁠)⁠┛⁠彡⁠┻⁠━⁠┻',
                style: TextStyle(fontSize: 48, color: Colors.grey),
              ),
              Text(
                'There was an error loading the queue.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ]),
    );
    ;
  }
}

class QueueEmpty extends StatelessWidget {
  const QueueEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverList(
      delegate: SliverChildListDelegate.fixed(<Widget>[
        Padding(
          padding: EdgeInsets.all(20.0),
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
              Text(
                'There\'s nothing currently in the queue...',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

class QueueItem extends ConsumerWidget {
  final Song song;
  final int index;
  final bool isTappable;
  const QueueItem({
    super.key,
    required this.song,
    required this.index,
    this.isTappable = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        title: Text(
          song.title,
          style: const TextStyle(
            fontFamilyFallback: <String>['NotoSansJP'],
            fontWeight: .w600,
          ),
        ),
        subtitle: Text(
          song.artist,
          style: const TextStyle(
            fontFamilyFallback: <String>['NotoSansJP'],
            fontWeight: .w500,
          ),
        ),
        leading: ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(5),
          child: Image.network(song.image!),
        ),
        dense: true,
        onTap: isTappable
            ? () async {
                final SpotifyUserService spotifyService =
                    SpotifyUserService.create();
                for (int i = 0; i < index + 1; i++) {
                  unawaited(spotifyService.skipForward());
                }
                ref.invalidate(spotifyPlaybackStateProvider);
              }
            : null,
      ),
    );
  }
}

class QueueItemAnimated extends StatelessWidget {
  final Animation<Offset> slideAnimation;
  final Animation<double> sizeAnimation;
  final Song song;
  final int index;
  final bool isTappable;
  const QueueItemAnimated({
    super.key,
    required this.slideAnimation,
    required this.song,
    required this.index,
    required this.sizeAnimation,
    this.isTappable = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: sizeAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: QueueItem(song: song, index: index, isTappable: true),
      ),
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
