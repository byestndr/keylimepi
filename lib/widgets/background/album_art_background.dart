import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotimmich/player_page.dart';
import 'package:spotimmich/providers/theme/album_art_provider.dart';
import 'package:spotimmich/settings/preferences.dart';
import 'package:spotimmich/widgets/control/seekbar.dart';

class AlbumArtBackground extends ConsumerStatefulWidget {
  const AlbumArtBackground({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AlbumArtBackgroundState();
}

class _AlbumArtBackgroundState extends ConsumerState<AlbumArtBackground> {
  double backgroundBlur = 80;
  bool onPageWidget = false;
  int position = 0;

  @override
  void initState() {
    super.initState();
    getBlur();
    getOnPageControls();
    getPosition();
  }

  Future<void> getPosition() async {
    final int? positionType = await AsyncPreferences().getIntValue(
      'player_alignment',
    );

    if (positionType == null) {
      setState(() {
        position = 0;
      });
    } else {
      setState(() {
        position = positionType;
      });
    }

    return;
  }

  Future<void> getOnPageControls() async {
    final int? isOnPageWidget = await AsyncPreferences().getIntValue(
      'playback_bar_position',
    );

    if (isOnPageWidget == 1) {
      onPageWidget = true;
    }

    return;
  }

  Future<void> getBlur() async {
    final double? blur = await AsyncPreferences().getDoubleValue(
      'background_blur_radius',
    );

    if (blur == null) {
      setState(() {
        backgroundBlur = 80;
      });
    } else {
      setState(() {
        backgroundBlur = blur;
      });
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<String> backgroundImage = ref.watch(albumImageProvider);
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
                sigmaX: backgroundBlur,
                sigmaY: backgroundBlur,
              ),
              child: Container(color: Colors.transparent),
            ),
          ),
          Column(
            crossAxisAlignment: position == 0
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            mainAxisAlignment: position == 0
                ? MainAxisAlignment.end
                : MainAxisAlignment.center,
            children: <Widget>[
              const MediaWidget(),
              onPageWidget
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