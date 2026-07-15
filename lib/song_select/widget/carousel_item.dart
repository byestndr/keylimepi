import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:key_limepi/backend/spotify/spotify_api.dart';
import 'package:key_limepi/pages/view_item.dart';

class CarouselItem extends StatelessWidget {
  final String? artist;
  final String title;
  final String image;
  final String id;
  final String uri;
  const CarouselItem({
    super.key,
    required this.title,
    required this.image,
    required this.id,
    required this.uri,
    this.artist,
  });

  void _navigateToPage(BuildContext context, Key key) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => ViewItem(
          id: id,
          uri: uri,
          name: title,
          artist: artist,
          image: image,
          key: key,
        ),
      ),
    );
  }

  void _startItem() {
    final SpotifyUserService spotifyAPI = SpotifyUserService.create();
    spotifyAPI.startFromContext(
      contextUri: uri.contains('track') ? [uri] : uri,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Key key = UniqueKey();

    return Hero(
      tag: key,
      child: Material(
        borderRadius: BorderRadius.circular(28),
        clipBehavior: .antiAlias,
        type: .canvas,
        color: Colors.transparent,
        child: InkWell(
          onLongPress: () => uri.contains('track') ? {} : _startItem(),
          onTap: () => uri.contains('track')
              ? _startItem()
              : _navigateToPage(context, key),
          child: Stack(
            fit: StackFit.passthrough,
            children: <Widget>[
              Padding(
                padding: EdgeInsetsGeometry.directional(
                  top: artist == null ? 110 : 95,
                  start: 12,
                ),
                child: Text(
                  title,
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
              artist != null
                  ? Padding(
                      padding: const EdgeInsetsGeometry.directional(
                        top: 115,
                        start: 12,
                      ),
                      child: Text(
                        artist!,
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
                    )
                  : const Padding(padding: .zero),
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
                    imageUrl: image,
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
