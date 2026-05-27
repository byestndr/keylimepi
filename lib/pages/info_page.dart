import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:key_limepi/pages/lyrics_page.dart';
import 'package:key_limepi/providers/settings_provider.dart';
import 'package:key_limepi/providers/theme/background_getter.dart';
import 'package:key_limepi/widgets/background/album_art_background.dart';
import 'package:key_limepi/widgets/control/alignedPlayers.dart';
import 'package:key_limepi/settings/preferences.dart';
import 'package:key_limepi/widgets/background/immich_background_carousel.dart';
import 'package:key_limepi/widgets/control/seekbar.dart';

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

class InfoPage extends ConsumerStatefulWidget {
  const InfoPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InfoPageState();
}

class _InfoPageState extends ConsumerState<InfoPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserValues preferences = ref.watch(userSettingsProvider);

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Stack(
        children: [
          preferences.immichBackgroundImage
              ? const ImmichCarousel()
              : const AlbumArtBackground(),

          PageView(
            scrollDirection: .vertical,
            controller: _pageController,
            onPageChanged: (int value) {
              if (value == 0) {
                ref.read(backgroundOpacityProvider.notifier).setOpacity(100);
                return;
              }

              ref.read(backgroundOpacityProvider.notifier).setOpacity(5);
              return;
            },
            children: [
              const LyricsPage(),
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
