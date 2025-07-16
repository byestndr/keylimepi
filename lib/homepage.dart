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
  dynamic backgroundImage = AssetImage('assets/imagePlaceholder.png');

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 10), (Timer timer) {
      RefreshLoop();
    });
  }

  void RefreshLoop() {
    setState(() {
      getBackgroundImage().then((value) {
        backgroundImage = value;
      });
    });
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
              scrollDirection: Axis.horizontal,
              flexWeights: [10, 1, 1],
              children: [
                FittedBox(
                  fit: BoxFit.cover,
                  child: Image(image: backgroundImage),
                ),
                FittedBox(
                  fit: BoxFit.cover,
                  child: Image(image: backgroundImage),
                ),
                FittedBox(
                  fit: BoxFit.cover,
                  child: Image(image: backgroundImage),
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
