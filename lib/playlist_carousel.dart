import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:spotimmich/settings/spotify/spotifyapi.dart';

class PlaylistCarousel extends StatefulWidget {
  final bool refresh;
  const PlaylistCarousel({super.key, required this.refresh});

  @override
  State<PlaylistCarousel> createState() => _PlaylistCarouselState();
}

class _PlaylistCarouselState extends State<PlaylistCarousel> {
  int playlistAmount = 1;
  late bool _refresh;

  @override
  void initState() {
    setPlaylistLength();
    _refresh = widget.refresh;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant PlaylistCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    refreshCarousel();

  }

  Future<List<dynamic>> getPlaylists() async {
    final dynamic response = await Interactions().getCachedPlaylists();
    final Map<dynamic, dynamic> body = jsonDecode(response);
    final List<dynamic> playlists = body['items'];
    return playlists;
  }

  Future<void> setPlaylistLength() async {
    final List<dynamic> playlists = await getPlaylists();

    setState(() {
      playlistAmount = playlists.length;
    });
    return;
  }

  Future<void> refreshCarousel() async {
    await Interactions().getUserPlaylists();
    await setPlaylistLength();
  }

  Future<void> startPlaylist(int playlistIndex) async {
    final List<dynamic> playlists = await getPlaylists();
    final String playlistID = playlists[playlistIndex]['uri'];
    await Interactions().resumePlayback(context_uri: playlistID);
  }

  @override
  Widget build(BuildContext context) {
    return CarouselView(
      onTap: (int index) async {
        await startPlaylist(index);
      },
      itemExtent: 200,
      children: List<Widget>.generate(
        playlistAmount,
        (int index) => FutureBuilder<List<dynamic>>(
          future: getPlaylists(),
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
                          top: 155,
                          start: 15,
                        ),
                        child: Text(
                          data[index]['name'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          softWrap: false,
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
                          child: Image.network(data[index]['images'][0]['url']),
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