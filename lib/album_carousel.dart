import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:spotimmich/settings/spotify/spotifyapi.dart';


class AlbumCarousel extends StatefulWidget {
  final bool refresh;
  const AlbumCarousel({super.key, required this.refresh});

  @override
  State<AlbumCarousel> createState() => _AlbumCarouselState();
}

class _AlbumCarouselState extends State<AlbumCarousel> {
  int itemsInCarousel = 1;
  late bool refresh;
  @override
  void initState() {
    refresh = widget.refresh;
    setCarouselLength();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AlbumCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    refreshCarousel();
  }

  Future<List<dynamic>> getAlbums() async {
    final dynamic response = await Interactions().getCachedAlbums();
    final Map<dynamic, dynamic> body = jsonDecode(response);
    final List<dynamic> albums = body['items'];
    return albums;
  }

  Future<void> setCarouselLength() async {
    final List<dynamic> albums = await getAlbums();

    setState(() {
      itemsInCarousel = albums.length;
    });
    return;
  }

  Future<void> refreshCarousel() async {
    await setCarouselLength();
  }

  Future<void> startAlbum(int albumIndex) async {
    final List<dynamic> playlists = await getAlbums();
    final String albumID = playlists[albumIndex]['album']['uri'];
    await Interactions().resumePlayback(context_uri: albumID);
  }

  @override
  Widget build(BuildContext context) {
    return CarouselView(
      onTap: (int index) async {
        startAlbum(index);
      },
      itemExtent: 200,
      children: List<Widget>.generate(
        itemsInCarousel,
        (int index) => FutureBuilder<List<dynamic>>(
          future: getAlbums(),
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                Widget child;
                dynamic data = snapshot.data;
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
                          data[index]['album']['name'],
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
                          data[index]['album']['artists'][0]['name'],
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
                            data[index]['album']['images'][0]['url'],
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
