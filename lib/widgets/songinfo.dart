import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotimmich/settings/spotify/spotifyauth.dart';
import 'package:spotimmich/settings/spotify/spotifyapi.dart';
import 'package:spotimmich/providers/song_info_provider.dart';

class SongInfo extends ConsumerWidget {
  const SongInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Song> currentSongInfo = ref.watch(infoGetterProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 0.0,
      children: <Widget>[
        Text(
          currentSongInfo.when(
            data: (data) {
              if (data.title == null) {
                return 'Nothing currently playing...';
              } else {
                return data.title!;
              }
            },
            error: (error, trace) {
              if (error.toString().contains('FormatException')) {
                return "Nothing currently playing...";
              } else {
                return error.toString();
              }
            },
            loading: () => "Nothing currently playing...",
          ),
          style: const TextStyle(
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
          currentSongInfo.when(
            data: (data) {
              if (data.title == null) {
                return "Start playing a song to control playback";
              } else {
                return data.artist!;
              }
            },
            error: (error, trace) {
              if (error.toString().contains('FormatException')) {
                return "Start playing a song to control playback";
              } else {
                return error.toString();
              }
            },
            loading: () => "Start playing a song to control playback",
          ),
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w300,
            fontFamilyFallback: ['Noto Sans'],
            fontFamily: 'Roboto Flex',
            color: Colors.white,
          ),
          maxLines: 1,
          overflow: TextOverflow.fade,
          softWrap: false,
        ),
      ],
    );
  }
}
