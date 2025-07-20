import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:spotimmich/settings/spotify/spotifyapi.dart';

class SongSelect extends StatelessWidget {
  const SongSelect({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.all(6),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
        ),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 400,
              child: CarouselView.weighted(
                flexWeights: const <int>[2],
                children: <Widget>[
                  FittedBox(
                    fit: BoxFit.cover,
                    child: Image.asset('assets/imagePlaceholder.png'),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Your Playlists',
                style: TextStyle(
                  fontFamily: 'Roboto Flex',
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 200, child: PlaylistCarousel()),
          ],
        ),
      ),
    );
  }
}

class PlaylistCarousel extends StatefulWidget {
  const PlaylistCarousel({super.key});

  @override
  State<PlaylistCarousel> createState() => _PlaylistCarouselState();
}

class _PlaylistCarouselState extends State<PlaylistCarousel> {
  int playlistAmount = 1;
  dynamic playlist;

  @override
  void initState() {
    setPlaylistLength();
    super.initState();
  }

  Future<List<dynamic>> getPlaylists() async {
    final dynamic response = await Interactions().getUserPlaylists();
    final Map<dynamic, dynamic> body = jsonDecode(response);
    final List<dynamic> playlists = body['items'];
    return playlists;
  }

  Future<void> setPlaylistLength() async {
    final List<dynamic> playlists = await getPlaylists();

    setState(() {
      playlistAmount = playlists.length;
    });
  }

  Future<String> getPlaylistCover(int playlistIndex) async {
    final List<dynamic> playlists = await getPlaylists();
    final String coverURL = playlists[playlistIndex]['images'][0]['url'];
    return coverURL;
  }

  @override
  Widget build(BuildContext context) {
    return CarouselView(
      itemExtent: 200,
      children: List<Widget>.generate(
        playlistAmount,
        (int index) => FutureBuilder<String>(
          future: getPlaylistCover(index),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            Widget child;
            String? data = snapshot.data;
            if (data == null) {
              child = const Center(child: CircularProgressIndicator());
            } else {
              child = Stack(
                fit: StackFit.passthrough,
                children: [
                  const Padding(
                    padding: EdgeInsetsGeometry.directional(
                      top: 140,
                      start: 10,
                    ),
                    child: Text(
                      'Helloooooooooooooo',
                      style: TextStyle(color: Colors.white, fontSize: 30),
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      softWrap: false,
                    ),
                  ),
                  FittedBox(fit: BoxFit.cover, child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                        begin: FractionalOffset.topCenter,
                        end: FractionalOffset.bottomCenter,
                        colors: <Color>[Colors.black12, Colors.black],
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.dstOut,
                    child: Image.network(data),
                  ),)
                  
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
