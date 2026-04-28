import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotimmich/providers/settings_provider.dart';
import 'package:spotimmich/widgets/background/album_art_background.dart';
import 'package:spotimmich/widgets/control/alignedPlayers.dart';
import 'package:spotimmich/settings/preferences.dart';
import 'package:spotimmich/widgets/background/immich_background_carousel.dart';

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

    return Row(
      children: <Widget>[
        Expanded(
          child: preferences.immichBackgroundImage
              ? const ImmichCarousel()
              : const AlbumArtBackground(),
        ),
      ],
    );
  }
}
