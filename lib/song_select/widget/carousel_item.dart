import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:key_limepi/backend/spotify/spotify_api.dart';
import 'package:key_limepi/pages/view_item.dart';

class CarouselItem extends StatelessWidget {
  final String? artist;
  final String title;
  final String image;
  final String id;
  const CarouselItem({
    super.key,
    required this.title,
    required this.image,
    required this.id,
    this.artist,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: .canvas,
      color: Colors.transparent,
      child: InkWell(
        onLongPress: () {
          final SpotifyUserService spotifyAPI = SpotifyUserService.create();
          spotifyAPI.startFromContext(id);
        },
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => ViewItem(id: id, name: title, artist: artist,),
            ),
          );
        },
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
    );
  }
}
