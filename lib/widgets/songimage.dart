import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:spotimmich/settings/spotify/spotifyapi.dart';
import 'package:spotimmich/providers/album_art_provider.dart';

class SongImage extends ConsumerStatefulWidget {
  final int imageMultiplier;
  const SongImage({super.key, required this.imageMultiplier});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SongImageState();
}

class _SongImageState extends ConsumerState<SongImage> {
  late int imageMultiplier;

  @override
  void initState() {
    super.initState();
    imageMultiplier = widget.imageMultiplier;
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<String> imageURL = ref.watch(albumImageProvider);
    return imageURL.when(
      data: (String data) {
        return Image.network(
          data,
          cacheHeight:
              (MediaQuery.of(context).devicePixelRatio * imageMultiplier)
                  .toInt(),
        );
      },
      error: (error, trace) {
        return Image.asset(
          'assets/imagePlaceholder.png',
          cacheHeight:
              (MediaQuery.of(context).devicePixelRatio * imageMultiplier)
                  .toInt(),
        );
      },
      loading: () => const CircularProgressIndicator(),
    );
  }
}
