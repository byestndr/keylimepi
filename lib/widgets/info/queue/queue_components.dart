
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:key_limepi/backend/spotify/spotify_api.dart';
import 'package:key_limepi/providers/spotify/song_info_provider.dart';
import 'package:key_limepi/providers/spotify/spotify_playbackstate.dart';

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