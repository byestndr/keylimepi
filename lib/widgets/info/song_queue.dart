import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotimmich/backend/spotify/spotify_api.dart';
import 'package:spotimmich/providers/spotify/song_info_provider.dart';
import 'dart:async';

class QueueSideSheet extends ConsumerStatefulWidget {
  const QueueSideSheet({super.key});

  @override
  ConsumerState<QueueSideSheet> createState() => _QueueSideSheetState();
}

class _QueueSideSheetState extends ConsumerState<QueueSideSheet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool isExpanded = ref.watch(isQueueExpandedProvider);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Easing.standard,
      width: isExpanded ? MediaQuery.of(context).devicePixelRatio * 300 : 0,
      child: isExpanded
          ? const Padding(
              padding: EdgeInsetsGeometry.directional(
                top: 8,
                bottom: 5,
                end: 6,
              ),
              child: QueueContent(),
            )
          : const Padding(padding: EdgeInsetsGeometry.zero),
    );
  }
}

class QueueContent extends StatefulWidget {
  const QueueContent({super.key});

  @override
  State<QueueContent> createState() => _QueueContentState();
}

class _QueueContentState extends State<QueueContent> {
  List<dynamic> currentQueue = <dynamic>[];
  Timer? timer;

  Future<void> getQueueItems() async {
    final SpotifyUserService spotifyAPI = SpotifyUserService.create();

    final Response spotifyResponse = await spotifyAPI.getQueue();
    final dynamic body = spotifyResponse.body;

    if (!mounted) {
      return;
    }

    try {
      setState(() {
        currentQueue = body['queue'];
      });
    } on TypeError {
      setState(() {
        currentQueue = body['queue'];
      });
    }

    return;
  }

  Future<List<dynamic>> returnQueue() async {
    if (currentQueue != <dynamic>[]) {
      return currentQueue;
    } else {
      return const <dynamic>[
        <String, List<Map<String, String>>>{
          'queue': <Map<String, String>>[
            <String, String>{'name': 'Nothing is playing'},
          ],
        },
      ];
    }
  }

  Future<void> skipToSong(int index) async {
    final SpotifyUserService spotifyAPI = SpotifyUserService.create();

    for (int i = 0; i < index + 1; i++) {
      unawaited(spotifyAPI.skipForward());
    }
    // For some reason, the first time an item is clicked, the
    // queue returned by Spotify doesn't change without delay.
    await Future.delayed(const Duration(milliseconds: 700));
    await getQueueItems();
    return;
  }

  @override
  void initState() {
    getQueueItems();
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 10), (Timer timer) {
      getQueueItems();
    });
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
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Queue',
              style: TextStyle(
                fontFamily: 'Roboto Flex',
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: returnQueue(),
              builder:
                  (
                    BuildContext context,
                    AsyncSnapshot<List<dynamic>> snapshot,
                  ) {
                    Widget child;
                    List<dynamic>? data = snapshot.data;
                    if (data != null) {
                      child = ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            onTap: () {
                              skipToSong(index);
                            },
                            leading: ClipRRect(
                              borderRadius: BorderRadiusGeometry.circular(5),
                              child: Image.network(
                                data[index]['album']['images'][0]['url'],
                                cacheWidth: 40,
                              ),
                            ),
                            title: Text(data[index]['name']),
                            subtitle: Text(data[index]['artists'][0]['name']),
                          );
                        },
                      );
                    } else {
                      child = const CircularProgressIndicator();
                    }
                    return child;
                  },
            ),
          ),
          const Padding(padding: EdgeInsetsGeometry.directional(bottom: 10)),
        ],
      ),
    );
  }
}
