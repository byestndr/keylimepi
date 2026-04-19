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
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10.0, bottom: 15.0),
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
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

void showQueueSheet(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (BuildContext context) {
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
            slivers: [
              SliverPersistentHeader(
                delegate: QueueHeader(),
                pinned: true,
                floating: true,
              ),
              queue.when(
                skipLoadingOnRefresh: true,
                skipLoadingOnReload: true,
                skipError: true,
                data: (List<Song> data) {
                  return SliverAnimatedList(
                    initialItemCount: data.length,
                    itemBuilder:
                        (
                          BuildContext context,
                          int index,
                          Animation<double> animation,
                        ) {
                          final slideAnimation = Tween<Offset>(
                            begin: const Offset(1, 0),
                            end: Offset.zero,
                          ).animate(animation);

                          return SlideTransition(
                            position: slideAnimation,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: ListTile(
                                title: Text(
                                  data[index].title,
                                  style: const TextStyle(
                                    fontFamilyFallback: ['NotoSansJP'],
                                    fontWeight: .w600
                                  ),
                                ),
                                subtitle: Text(
                                  data[index].artist,
                                  style: const TextStyle(
                                    fontFamilyFallback: ['NotoSansJP'],
                                    fontWeight: .w500
                                  ),
                                ),
                                leading: ClipRRect(
                                  borderRadius: BorderRadiusGeometry.circular(
                                    5,
                                  ),
                                  child: Image.network(data[index].image!),
                                ),
                                dense: true,
                                onTap: () async {
                                  final SpotifyUserService spotifyService =
                                      SpotifyUserService.create();
                                  for (int i = 0; i < index + 1; i++) {
                                    unawaited(spotifyService.skipForward());
                                  }
                                  ref.invalidate(spotifyPlaybackStateProvider);
                                },
                              ),
                            ),
                          );
                        },
                  );
                },
                error: (Object error, StackTrace stackTrace) {
                  return const SliverList(
                    delegate: SliverChildListDelegate.fixed([
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: .center,
                          mainAxisAlignment: .center,
                          children: [
                            Text(
                              '(⁠┛⁠◉⁠Д⁠◉⁠)⁠┛⁠彡⁠┻⁠━⁠┻',
                              style: TextStyle(fontSize: 48),
                            ),
                            Text(
                              'There was an error loading the queue.',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  );
                },
                loading: () {
                  return const SliverList(
                    delegate: SliverChildListDelegate.fixed([
                      LinearProgressIndicator(minHeight: 2),
                    ]),
                  );
                },
              ),
            ],
          );
        },
      );
    },
  );
}
