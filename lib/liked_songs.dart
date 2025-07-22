import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:spotimmich/settings/spotify/spotifyapi.dart';

class SongCarousel extends StatefulWidget {
  final bool refresh;
  const SongCarousel({super.key, required this.refresh});

  @override
  State<SongCarousel> createState() => _SongCarouselState();
}

class _SongCarouselState extends State<SongCarousel> {
  int songAmount = 1;
  late bool _refresh;

  @override
  void initState() {
    setCarouselLength();
    _refresh = widget.refresh;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SongCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    refreshCarousel();
  }

  Future<List<dynamic>> getSongs() async {
    final dynamic response = await Interactions().getCachedSongs();
    final Map<dynamic, dynamic> body = jsonDecode(response);
    final List<dynamic> songs = body['items'];
    return songs;
  }

  Future<void> setCarouselLength() async {
    final List<dynamic> songs = await getSongs();

    if (mounted) {
      setState(() {
        songAmount = songs.length;
      });
    }
    return;
  }

  Future<void> refreshCarousel() async {
    await setCarouselLength();
  }

  Future<void> startPlaylist(int songIndex) async {
    final List<dynamic> songs = await getSongs();
    final String songID = songs[songIndex]['track']['uri'];
    await Interactions().resumePlayback(context_uri: songID);
  }

  @override
  Widget build(BuildContext context) {
    return CarouselView(
      onTap: (int index) async {
        await startPlaylist(index);
      },
      itemExtent: 200,
      children: List<Widget>.generate(
        songAmount,
        (int index) => FutureBuilder<List<dynamic>>(
          future: getSongs(),
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                Widget child;
                List<dynamic>? data = snapshot.data;
                if (data == null) {
                  child = const Center(child: CircularProgressIndicator());
                } else {
                  child = Stack(
                    fit: StackFit.passthrough,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsetsGeometry.directional(
                          top: 135,
                          start: 15,
                        ),
                        child: Text(
                          data[index]['track']['name'],
                          style: const TextStyle(
                            fontFamily: 'Roboto Flex',
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          softWrap: false,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsGeometry.directional(
                          top: 162,
                          start: 15,
                        ),
                        child: Text(
                          data[index]['track']['album']['artists'][0]['name'],
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          softWrap: false,
                          style: const TextStyle(
                            fontSize: 15,
                            fontFamily: 'Roboto Flex',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.cover,
                        child: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return const LinearGradient(
                              begin: FractionalOffset.topCenter,
                              end: FractionalOffset.bottomCenter,
                              colors: <Color>[Colors.black12, Colors.black],
                            ).createShader(bounds);
                          },
                          blendMode: BlendMode.dstOut,
                          child: Image.network(
                            data[index]['track']['album']['images'][0]['url'],
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return child;
              },
        ),
      ),
    );
  }
}
