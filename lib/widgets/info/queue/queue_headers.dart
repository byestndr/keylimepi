import 'package:flutter/material.dart';
import 'package:spotimmich/providers/spotify/song_info_provider.dart';
import 'package:spotimmich/widgets/info/queue/queue_components.dart';

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