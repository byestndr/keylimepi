import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:spotimmich/settings/spotify/spotifyapi.dart';

class SongSelect extends StatefulWidget {
  const SongSelect({super.key});

  @override
  State<SongSelect> createState() => _SongSelectState();
}

class _SongSelectState extends State<SongSelect> {
  bool refreshing = false;

  Future<void> refreshChildren() async {
    setState(() {
      refreshing = true;
    });
  }

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
        child: RefreshIndicator(
          child: ListView(
            addAutomaticKeepAlives: true,
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
              SizedBox(
                height: 200,
                child: PlaylistCarousel(refresh: refreshing),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Saved Albums',
                  style: TextStyle(
                    fontFamily: 'Roboto Flex',
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 200, child: AlbumCarousel(refresh: refreshing,)),
            ],
          ),
          onRefresh: () async {
            return refreshChildren();
          },
        ),
      ),
    );
  }
}

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
    await Interactions().getSavedAlbums();
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
