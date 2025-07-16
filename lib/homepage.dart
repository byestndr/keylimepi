import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';
import 'songinfo.dart';
import 'songimage.dart';
import 'package:spotimmich/settings/immich/immichtokendialog.dart';

class MediaWidget extends StatelessWidget {
  const MediaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SongImage(),
        Padding(
          padding: EdgeInsetsGeometry.directional(bottom: 16),
          child: SongInfo(),
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
  dynamic backgroundImage0 = AssetImage('assets/imagePlaceholder.png');
  dynamic backgroundImage1 = AssetImage('assets/imagePlaceholder.png');
  dynamic backgroundImage2 = AssetImage('assets/imagePlaceholder.png');

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
      carouselController.animateToItem(
        currentCarouselItem,
        curve: Curves.ease,
        duration: Duration(seconds: 2),
      );
    });
  }

  Future<void> RefreshLoop() async {
    dynamic image = await getBackgroundImage();

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

    await Future.delayed(Duration(seconds: 1));
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: SizedBox.expand(
            child: CarouselView.weighted(
              controller: carouselController,
              scrollDirection: Axis.horizontal,
              itemSnapping: true,
              consumeMaxWeight: false,
              flexWeights: [1],
              children: [
                FittedBox(
                  fit: BoxFit.cover,
                  child: Image(image: backgroundImage0),
                ),
                FittedBox(
                  fit: BoxFit.cover,
                  child: Image(image: backgroundImage1),
                ),
                FittedBox(
                  fit: BoxFit.cover,
                  child: Image(image: backgroundImage2),
                ),
              ],
            ),
          ),
        ),
        MediaWidget(),
      ],
    );
  }
}
