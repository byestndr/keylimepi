import 'package:flutter/material.dart';
import 'package:spotimmich/settings/immich/immichpreferences.dart';
import 'dart:async';
import 'package:spotimmich/widgets/songinfo.dart';
import 'package:spotimmich/widgets/songimage.dart';

const int imageBreakpoint = 600;

class MediaWidget extends StatelessWidget {
  const MediaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        MediaQuery.of(context).size.width >= imageBreakpoint
            ? const SongImage()
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

class ImmichCarousel extends StatefulWidget {
  const ImmichCarousel({super.key});

  @override
  State<ImmichCarousel> createState() => _ImmichCarouselState();
}

class _ImmichCarouselState extends State<ImmichCarousel> {
  Timer? timer;
  dynamic backgroundImage0 = Image.asset('assets/imagePlaceholder.png');
  dynamic backgroundImage1 = Image.asset('assets/imagePlaceholder.png');
  dynamic backgroundImage2 = Image.asset('assets/imagePlaceholder.png');

  CarouselController carouselController = CarouselController(initialItem: 0);
  int currentCarouselItem = 0;

  void changeCarouselItem() {
    switch (currentCarouselItem) {
      case 0 || 1:
        currentCarouselItem++;
      default:
        currentCarouselItem = 0;
    }
  }

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) async {
      await RefreshLoop();
      changeCarouselItem();
      await carouselController.animateToItem(
        currentCarouselItem,
        curve: Curves.ease,
        duration: const Duration(seconds: 2),
      );
    });
  }

  Future<void> RefreshLoop() async {
    dynamic image = await getBackgroundImage(
      MediaQuery.of(context).devicePixelRatio,
    );

    setState(() {
      switch (currentCarouselItem) {
        case 0:
          backgroundImage1 = image;
        case 1:
          backgroundImage2 = image;
        case 2:
          backgroundImage0 = image;
      }
    });

    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  void dispose() {
    timer?.cancel();
    carouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              children: <Widget>[
                FittedBox(fit: BoxFit.cover, child: backgroundImage0),
                FittedBox(fit: BoxFit.cover, child: backgroundImage1),
                FittedBox(fit: BoxFit.cover, child: backgroundImage2),
              ],
            ),
          ),
        ),
        const MediaWidget(),
      ],
    );
  }
}
