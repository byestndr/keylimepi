import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:spotimmich/settings/spotify/spotifyapi.dart';

class SongImage extends StatefulWidget {
  const SongImage({super.key});

  @override
  State<SongImage> createState() => _SongImageState();
}

class _SongImageState extends State<SongImage> {
  Timer? timer;
  dynamic songArt = Image.asset('assets/imagePlaceholder.png', width: 300,);
  static const double imageRadius = 28;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      RefreshLoop();
    });
  }

  void RefreshLoop() {
    setState(() {
      Interactions()
          .cachedPlaybackStateResponse(functionName: 'SongImage')
          .then((String value) {
            try {
              final dynamic body = jsonDecode(value);
              final String imageURL = body['item']['album']['images'][0]['url'];
              songArt = Image.network(imageURL, cacheHeight: (MediaQuery.of(context).devicePixelRatio * 200).toInt(),);
            } on FormatException {
              songArt = Image.asset('assets/imagePlaceholder.png', cacheHeight: (MediaQuery.of(context).devicePixelRatio * 200).toInt(),);
            } on NoSuchMethodError {
              songArt = Image.asset('assets/imagePlaceholder.png', cacheHeight: (MediaQuery.of(context).devicePixelRatio * 200).toInt(),);
            }
          });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.all(16),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(imageRadius)),
            color: Colors.transparent,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black38,
                blurRadius: 2,
                offset: Offset(0, 2),
              ),
            ],
          ),

          child: ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(imageRadius),
            child: songArt
          ),
        ),
      ),
    );
  }
}
