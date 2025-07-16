import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:spotimmich/settings/spotify/spotifyauth.dart';
import 'settings/spotify/spotifyapi.dart';

class SongInfo extends StatefulWidget {
  const SongInfo({super.key});

  @override
  State<SongInfo> createState() => _SongInfoState();
}

class _SongInfoState extends State<SongInfo> {
  String title = "Nothing currently playing...";
  String artist = "Start playing a song to control playback";
  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      RefreshLoop();
    });
  }

  void RefreshLoop() {
    setState(() {
      Interactions().cachedPlaybackStateResponse(functionName: 'SongInfo').then(
        (value) {
          try {
            final body = jsonDecode(value);
            artist = body['item']['album']['artists'][0]['name'];
            title = body['item']['name'];
          } on FormatException {
            title = "Nothing currently playing...";
            artist = "Start playing a song to control playback";
          } on NoSuchMethodError {
            isLoggedIn();
            title = "Not signed in";
            artist = "Open settings and sign in to get song data";
          }
        },
      );
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 0.0,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 64.0,
            fontFamilyFallback: ['Noto Sans'],
            fontWeight: FontWeight.w800,
            fontFamily: 'Roboto Flex',
            color: Colors.white,
          ),
          maxLines: 1,
          overflow: TextOverflow.fade,
          softWrap: false,
        ),

        Text(
          artist,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w300,
            fontFamilyFallback: ['Noto Sans'],
            fontFamily: 'Roboto Flex',
            color: Colors.white,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
