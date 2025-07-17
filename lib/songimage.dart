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
  dynamic songArt = AssetImage('assets/imagePlaceholder.png');
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
              songArt = NetworkImage(imageURL);
            } on FormatException {
              songArt = AssetImage('assets/imagePlaceholder.png');
            } on NoSuchMethodError {
              songArt = AssetImage('assets/imagePlaceholder.png');
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
      padding: EdgeInsetsGeometry.all(16),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          decoration: BoxDecoration(
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
            child: Image(
              image: ResizeImage(
                songArt,
                width: MediaQuery.sizeOf(context).width ~/ 6,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
