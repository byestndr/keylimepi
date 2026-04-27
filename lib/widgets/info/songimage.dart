import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:spotimmich/providers/theme/album_art_provider.dart';
import 'package:spotimmich/widgets/info/queue/queue_sheet.dart';

class SongImage extends ConsumerStatefulWidget {
  const SongImage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SongImageState();
}

class _SongImageState extends ConsumerState<SongImage> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<String> imageURL = ref.watch(albumImageProvider);
    return Material(
      type: MaterialType.canvas,
      borderRadius: BorderRadius.circular(15),
      clipBehavior: Clip.antiAlias,
      shadowColor: Colors.black,
      color: Colors.transparent,
      elevation: 4,
      child: Stack(
        children: [
          imageURL.when(
            skipLoadingOnRefresh: true,
            skipLoadingOnReload: true,
            skipError: true,
            data: (String data) {
              return CachedNetworkImage(
                imageUrl: data,
                height:
                    (MediaQuery.of(context).size.height *
                        MediaQuery.of(context).devicePixelRatio) /
                    5,
                fadeInCurve: const Cubic(0.05, 0.7, 0.1, 1.0),
                fadeInDuration: const Duration(milliseconds: 400),
                fadeOutCurve: const Cubic(0.3, 0.0, 0.8, 0.15),
                fadeOutDuration: const Duration(milliseconds: 200),
              );
            },
            error: (Object error, StackTrace trace) {
              return Image.asset(
                'assets/imagePlaceholder.png',
                height:
                    (MediaQuery.of(context).size.height *
                        MediaQuery.of(context).devicePixelRatio) /
                    5,
              );
            },
            loading: () => Image.asset(
              'assets/imagePlaceholder.png',
              height:
                  (MediaQuery.of(context).size.height *
                      MediaQuery.of(context).devicePixelRatio) /
                  5,
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(onTap: () => showQueueSheet(context, ref)),
            ),
          ),
        ],
      ),
    );
  }
}
