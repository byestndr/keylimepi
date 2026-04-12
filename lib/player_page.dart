import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotimmich/widgets/background/album_art_background.dart';
import 'package:spotimmich/widgets/control/alignedPlayers.dart';
import 'package:spotimmich/settings/preferences.dart';
import 'package:spotimmich/widgets/background/immich_background_carousel.dart';
import 'dart:async';

class MediaWidget extends StatefulWidget {
  const MediaWidget({super.key});

  @override
  State<MediaWidget> createState() => _MediaWidgetState();
}

class _MediaWidgetState extends State<MediaWidget> {
  int position = 0;
  bool onPageWidget = false;

  @override
  void initState() {
    super.initState();
    getPosition();
    getOnPageControls();
  }

  Future<void> getOnPageControls() async {
    final int? isOnPageWidget = await AsyncPreferences.getIntValue(
      'playback_bar_position',
    );

    if (isOnPageWidget == 1) {
      onPageWidget = true;
    }

    return;
  }

  Future<void> getPosition() async {
    final int? positionType = await AsyncPreferences.getIntValue(
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

  @override
  Widget build(BuildContext context) {
    return position != 0
        ? CenteredInfo(onPageControls: onPageWidget)
        : BottomLeftInfo(onPageControls: onPageWidget);
  }
}

class FullPlayerPage extends ConsumerStatefulWidget {
  const FullPlayerPage({super.key});

  @override
  ConsumerState<FullPlayerPage> createState() => _FullPlayerPageState();
}

class _FullPlayerPageState extends ConsumerState<FullPlayerPage> {
  bool isImmich = false;

  @override
  void initState() {
    super.initState();
    getBackgroundType();
  }

  Future<void> getBackgroundType() async {
    final bool? backgroundState = await AsyncPreferences.getBoolValue(
      'immich_background',
    );

    if (backgroundState == null) {
      setState(() {
        isImmich = false;
      });
    } else {
      setState(() {
        isImmich = backgroundState;
      });
    }

    return;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: isImmich ? const ImmichCarousel() : const AlbumArtBackground(),
        ),
      ],
    );
  }
}
