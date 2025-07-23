import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:spotimmich/settings/spotify/spotifyapi.dart';

class QueueSideSheet extends StatefulWidget {
  const QueueSideSheet({super.key});

  @override
  State<QueueSideSheet> createState() => _QueueSideSheetState();
}

class _QueueSideSheetState extends State<QueueSideSheet> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOut,
      width: MediaQuery.of(context).devicePixelRatio * 300,
      child: const Padding(
        padding: EdgeInsetsGeometry.directional(top: 8, bottom: 5, end: 6),
        child: QueueContent(),
      ),
    );
  }
}

class QueueContent extends StatefulWidget {
  const QueueContent({super.key});

  @override
  State<QueueContent> createState() => _QueueContentState();
}

class _QueueContentState extends State<QueueContent> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  List<dynamic> currentQueue = [];
  String? currentSong;

  Future<void> getQueueItems() async {
    final String response = await Interactions().getQueue();

    final Map<String, dynamic> body = jsonDecode(response);

    if (!mounted) {
      return;
    }

    if (currentSong == null || currentQueue == []) {
      setState(() {
        currentSong = body['currently_playing']['name'];
        currentQueue = body['queue'];
        listKey.currentState?.insertAllItems(0, currentQueue.length);
      });
    }

    String newCurrentSong = body['currently_playing']['name'];
    List<dynamic> newCurrentQueue = body['queue'];

    if (newCurrentSong != currentSong) {
      currentSong = newCurrentSong;

      for (final (x) in currentQueue) {
        if (newCurrentQueue.contains(x)) {
          final int maximumItemToRemove = currentQueue.indexOf(x) - 1;
          currentQueue.removeRange(0, maximumItemToRemove);
          newCurrentQueue.removeAt(x);
          currentQueue.addAll(newCurrentQueue);

          break;
        }
      }
    }

    return;
  }

  @override
  void initState() {
    getQueueItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text('Queue', style: TextStyle(fontFamily: 'Roboto Flex', fontSize: 30, fontWeight: FontWeight.w600),),
          ),
          Expanded(
            child: AnimatedList(
              initialItemCount: currentQueue.length,
              key: listKey,
              itemBuilder:
                  (
                    BuildContext context,
                    int index,
                    Animation<double> animation,
                  ) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(1, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: ListTile(leading: Icon(Icons.music_note), title: Text(currentQueue[index]['name']),),
                    );
                  },
            ),
          ),
        ],
      ),
    );
  }
}
