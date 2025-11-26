import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotimmich/widgets/alignedPlayers.dart';
import 'package:spotimmich/providers/album_art_provider.dart';
import 'package:spotimmich/providers/background_getter.dart';
import 'package:spotimmich/settings/preferences.dart';
import 'dart:async';

import 'package:spotimmich/widgets/controls.dart';
import 'package:spotimmich/widgets/seekbar.dart';

const int imageBreakpoint = 600;

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
    final int? isOnPageWidget = await AsyncPreferences().getIntValue(
      'playback_bar_position',
    );

    if (isOnPageWidget == 1) {
      onPageWidget = true;
    }

    return;
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

  @override
  Widget build(BuildContext context) {
    return position != 0 ? CenteredInfo(onPageControls: onPageWidget,) : BottomLeftInfo(onPageControls: onPageWidget,);
  }
}

class ImmichCarousel extends ConsumerStatefulWidget {
  const ImmichCarousel({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ImmichCarouselState();
}

class _ImmichCarouselState extends ConsumerState<ImmichCarousel> {
  Timer? timer;
  static const int carouselLength = 3;

  CarouselController carouselController = CarouselController(initialItem: 0);
  int currentCarouselItem = 0;

  Future<void> changeCarouselItem() async {
    final int newCarouselItem = (currentCarouselItem + 1) % carouselLength;

    await carouselController.animateToItem(
      newCarouselItem,
      curve: Curves.ease,
      duration: const Duration(seconds: 2),
    );

    if (!mounted) {
      return;
    }

    switch (newCarouselItem) {
      case 0:
        ref
            .read(
              background3Provider(
                pixelRatio: MediaQuery.of(context).devicePixelRatio,
              ).notifier,
            )
            .refreshImage();
      case 1:
        ref
            .read(
              background1Provider(
                pixelRatio: MediaQuery.of(context).devicePixelRatio,
              ).notifier,
            )
            .refreshImage();
      case 2:
        ref
            .read(
              background2Provider(
                pixelRatio: MediaQuery.of(context).devicePixelRatio,
              ).notifier,
            )
            .refreshImage();
    }

    currentCarouselItem = newCarouselItem;
  }

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) async {
      await changeCarouselItem();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    carouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<Image> image1 = ref.watch(
      background1Provider(pixelRatio: MediaQuery.of(context).devicePixelRatio),
    );
    AsyncValue<Image> image2 = ref.watch(
      background2Provider(pixelRatio: MediaQuery.of(context).devicePixelRatio),
    );
    AsyncValue<Image> image3 = ref.watch(
      background3Provider(pixelRatio: MediaQuery.of(context).devicePixelRatio),
    );

    return Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: SizedBox.expand(
            child: CarouselView.weighted(
              controller: carouselController,
              scrollDirection:
                  MediaQuery.of(context).size.width >= imageBreakpoint
                  ? Axis.horizontal
                  : Axis.vertical,
              itemSnapping: true,
              flexWeights: const <int>[1],
              children: <Widget>[
                FittedBox(
                  fit: BoxFit.cover,
                  child: image1.when(
                    data: (Image data) => data,
                    error: (Object error, StackTrace stack) {
                      Image.asset('assets/imagePlaceholder.png');
                    },
                    loading: () => const Padding(
                      padding: EdgeInsets.all(150.0),
                      child: SizedBox.square(
                        dimension: 50,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.cover,
                  child: image2.when(
                    data: (Image data) => data,
                    error: (Object error, StackTrace stack) {
                      Image.asset('assets/imagePlaceholder.png');
                    },
                    loading: () => const Padding(
                      padding: EdgeInsets.all(150.0),
                      child: SizedBox.square(
                        dimension: 50,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.cover,
                  child: image3.when(
                    data: (Image data) => data,
                    error: (Object error, StackTrace stack) {
                      Image.asset('assets/imagePlaceholder.png');
                    },
                    loading: () => const Padding(
                      padding: EdgeInsets.all(150.0),
                      child: SizedBox.square(
                        dimension: 50,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const MediaWidget(),
      ],
    );
  }
}

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
    final bool? backgroundState = await AsyncPreferences().getBoolValue(
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
