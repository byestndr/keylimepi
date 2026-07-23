import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:key_limepi/backend/spotify/spotify_api.dart';
import 'package:key_limepi/pages/view_item.dart';
import 'package:key_limepi/song_select/song_select_item.dart';

class CarouselItem extends StatelessWidget {
  final SpotifyItem item;
  const CarouselItem({super.key, required this.item});

  void _navigateToPage(BuildContext context, Key key) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => ViewItem(item: item as SpotifyCollection, key: key),
      ),
    );
  }

  void _startItem() {
    final SpotifyUserService spotifyAPI = SpotifyUserService.create();
    spotifyAPI.startFromContext(
      contextUri: item is SpotifySong ? [item.uri] : item.uri,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Key key = UniqueKey();
    final bool isItemSong = item is SpotifySong;

    return Hero(
      tag: key,
      child: Material(
        borderRadius: BorderRadius.circular(28),
        clipBehavior: .antiAlias,
        type: .canvas,
        color: Colors.transparent,
        child: InkWell(
          onLongPress: () => isItemSong ? {} : _startItem(),
          onTap: () =>
              isItemSong ? _startItem() : _navigateToPage(context, key),
          child: Stack(
            fit: StackFit.passthrough,
            children: <Widget>[
              Padding(
                padding: EdgeInsetsGeometry.directional(
                  top: item.runtimeType != SpotifyPlaylist ? 110 : 95,
                  start: 12,
                ),
                child: Text(
                  item.name,
                  style: const TextStyle(
                    fontFamily: 'Roboto Flex',
                    fontFamilyFallback: <String>['NotoSansJP'],
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  softWrap: false,
                ),
              ),

              switch (item) {
                SpotifySong song => _ArtistText(artist: song.artist),
                SpotifyAlbum album => _ArtistText(artist: album.artist),
                _ => const Padding(padding: .zero),
              },

              // Gradient
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
                  child: CachedNetworkImage(
                    imageUrl: item.image.toString(),
                    fadeInCurve: const Cubic(0.05, 0.7, 0.1, 1.0),
                    fadeInDuration: const Duration(milliseconds: 400),
                    fadeOutCurve: const Cubic(0.3, 0.0, 0.8, 0.15),
                    fadeOutDuration: const Duration(milliseconds: 200),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArtistText extends StatelessWidget {
  final String artist;
  const _ArtistText({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.directional(top: 115, start: 12),
      child: Text(
        artist,
        overflow: TextOverflow.fade,
        maxLines: 1,
        softWrap: false,
        style: const TextStyle(
          fontSize: 12,
          fontFamily: 'Roboto Flex',
          fontFamilyFallback: <String>['NotoSansJP'],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
