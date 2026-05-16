import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotimmich/providers/settings_provider.dart';
import 'package:spotimmich/widgets/background/album_art_background.dart';
import 'package:spotimmich/widgets/control/alignedPlayers.dart';
import 'package:spotimmich/settings/preferences.dart';
import 'package:spotimmich/widgets/background/immich_background_carousel.dart';
import 'package:spotimmich/widgets/control/seekbar.dart';

class MediaWidget extends ConsumerWidget {
  const MediaWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserValues preferences = ref.watch(userSettingsProvider);
    return preferences.albumInfoCentered
        ? const CenteredInfo()
        : const BottomLeftInfo();
  }
}

class InfoPage extends ConsumerWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserValues preferences = ref.watch(userSettingsProvider);

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: PageView(
        children: [
          Stack(
            children: [
              preferences.immichBackgroundImage
                  ? const ImmichCarousel()
                  : const AlbumArtBackground(),

              Column(
                crossAxisAlignment: preferences.albumInfoCentered
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                mainAxisAlignment: preferences.albumInfoCentered
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.end,
                children: <Widget>[
                  const MediaWidget(),

                  // If the playback bar is set to show on page
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
        ],
      ),
    );
  }
}
