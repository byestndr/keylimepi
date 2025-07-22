import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:spotimmich/settings/spotify/spotifyapi.dart';

class SongImage extends StatefulWidget {
  final int imageMultiplier;
  const SongImage({super.key, required this.imageMultiplier});

  @override
  State<SongImage> createState() => _SongImageState();
}

class _SongImageState extends State<SongImage> {
  Timer? timer;
  dynamic songArt = Image.asset('assets/imagePlaceholder.png', width: 300);
  late int imageMultiplier;

  @override
  void initState() {
    super.initState();
    imageMultiplier = widget.imageMultiplier;
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      RefreshLoop();
    });
  }

  void RefreshLoop() {
    if (!mounted) {
      return;
    }
    setState(() {
      Interactions()
          .cachedPlaybackStateResponse(functionName: 'SongImage')
          .then((String value) {
            try {
              final dynamic body = jsonDecode(value);
              final String imageURL = body['item']['album']['images'][0]['url'];
              songArt = Image.network(
                imageURL,
                cacheHeight:
                    (MediaQuery.of(context).devicePixelRatio * imageMultiplier)
                        .toInt(),
              );
            } on FormatException {
              songArt = Image.asset(
                'assets/imagePlaceholder.png',
                cacheHeight:
                    (MediaQuery.of(context).devicePixelRatio * imageMultiplier)
                        .toInt(),
              );
            } on NoSuchMethodError {
              songArt = Image.asset(
                'assets/imagePlaceholder.png',
                cacheHeight:
                    (MediaQuery.of(context).devicePixelRatio * imageMultiplier)
                        .toInt(),
              );
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
    return songArt;
  }
}
