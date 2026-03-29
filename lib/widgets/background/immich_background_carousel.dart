import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotimmich/player_page.dart';
import 'package:spotimmich/providers/theme/background_getter.dart';

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
                      return Image.asset('assets/imagePlaceholder.png');
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
                      return Image.asset('assets/imagePlaceholder.png');
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
                      return Image.asset('assets/imagePlaceholder.png');
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