import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotimmich/providers/background_getter.dart';
import 'package:spotimmich/settings/immich/immichpreferences.dart';
import 'dart:async';
import 'package:spotimmich/widgets/songinfo.dart';
import 'package:spotimmich/widgets/songimage.dart';

const int imageBreakpoint = 600;

class MediaWidget extends StatelessWidget {
  const MediaWidget({super.key});
  static const double imageRadius = 28;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        MediaQuery.of(context).size.width >= imageBreakpoint
            ? Padding(
                padding: const EdgeInsetsGeometry.all(16),
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(imageRadius),
                    ),
                    color: Colors.transparent,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 2,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),

                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(imageRadius),
                    child: const SongImage(imageMultiplier: 200),
                  ),
                ),
              )
            : const Padding(padding: EdgeInsetsGeometry.directional(start: 20)),
        const Expanded(
          child: Padding(
            padding: EdgeInsetsGeometry.directional(bottom: 16),
            child: SongInfo(),
          ),
        ),
      ],
    );
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
              children: [
                FittedBox(
                  fit: BoxFit.cover,
                  child: image1.when(
                    data: (data) => data,
                    error: (error, stack) {
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
                    data: (data) => data,
                    error: (error, stack) {
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
                    data: (data) => data,
                    error: (error, stack) {
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

class FullPlayerPage extends StatelessWidget {
  const FullPlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(children: [Expanded(child: ImmichCarousel())]);
  }
}
