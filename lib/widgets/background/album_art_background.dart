import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotimmich/player_page.dart';
import 'package:spotimmich/providers/settings_provider.dart';
import 'package:spotimmich/providers/theme/album_art_provider.dart';
import 'package:spotimmich/settings/preferences.dart';
import 'package:spotimmich/widgets/control/seekbar.dart';

class AlbumArtBackground extends ConsumerWidget {
  const AlbumArtBackground({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<String> backgroundImage = ref.watch(albumImageProvider);
    final UserValues preferences = ref.watch(userSettingsProvider);

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Easing.standard,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: backgroundImage.when(
                  skipError: true,
                  skipLoadingOnRefresh: true,
                  skipLoadingOnReload: true,
                  data: (String data) {
                    return NetworkImage(data);
                  },
                  error: (Object error, StackTrace stack) {
                    return const AssetImage('assets/imagePlaceholder.png');
                  },
                  loading: () =>
                      const AssetImage('assets/imagePlaceholder.png'),
                ),
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(28),
            clipBehavior: Clip.hardEdge,
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: preferences.backgroundBlur,
                sigmaY: preferences.backgroundBlur,
              ),
              child: Container(color: Colors.transparent),
            ),
          ),
          Column(
            crossAxisAlignment: preferences.albumInfoCentered
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            mainAxisAlignment: preferences.albumInfoCentered
                ? MainAxisAlignment.center
                : MainAxisAlignment.end,
            children: <Widget>[
              const MediaWidget(),
              preferences.playbackBarPosition == 1
                  ? const Padding(
                    padding: EdgeInsetsDirectional.only(bottom: 5),
                    child: SizedBox(width: 800, child: ProgressSlider()),
                  )
                  : const Padding(padding: EdgeInsetsGeometry.zero),
            ],
          ),
        ],
      ),
    );
  }
}