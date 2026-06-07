import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CarouselItem extends StatelessWidget {
  final String? artist;
  final String title;
  final String image;
  const CarouselItem({
    super.key,
    required this.title,
    required this.image,
    this.artist,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        Padding(
          padding: EdgeInsetsGeometry.directional(
            top: artist == null ? 150 : 135,
            start: 15,
          ),
          child: Text(
            title,
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
        artist != null
            ? Padding(
                padding: const EdgeInsetsGeometry.directional(
                  top: 162,
                  start: 15,
                ),
                child: Text(
                  artist!,
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  softWrap: false,
                  style: const TextStyle(
                    fontSize: 15,
                    fontFamily: 'Roboto Flex',
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
    );
  }
}
