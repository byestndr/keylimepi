import 'package:flutter/material.dart';
import 'package:spotimmich/settings/immich/immichpage.dart';
import 'package:spotimmich/settings/immich/immichpreferences.dart';
import 'package:spotimmich/widgets/song_queue.dart';
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

class ImmichCarousel extends StatefulWidget {
  const ImmichCarousel({super.key});

  @override
  State<ImmichCarousel> createState() => _ImmichCarouselState();
}

class _ImmichCarouselState extends State<ImmichCarousel> {
  Timer? timer;
  late final List<Widget> carouselBackgroundWidgets;
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

    currentCarouselItem = newCarouselItem;
  }

  @override
  void initState() {
    super.initState();

    carouselBackgroundWidgets = List<Widget>.generate(
      carouselLength,
      (_) => Image.asset('assets/imagePlaceholder.png'),
    );

    timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) async {
      await refreshImages();
      await changeCarouselItem();
    });
  }

  Future<void> refreshImages() async {
    final int nextCarouselItem = (currentCarouselItem + 1) % carouselLength;

    dynamic image = await getBackgroundImage(
      MediaQuery.of(context).devicePixelRatio,
    );
  if (mounted) {
    setState(() {
      carouselBackgroundWidgets[nextCarouselItem] = image;
    });
  }
    await Future.delayed(const Duration(milliseconds: 500));
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
              children: carouselBackgroundWidgets.map((Widget image) {
                return FittedBox(fit: BoxFit.cover, child: image);
              }).toList(),
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
    return const Row(children: [Expanded(child: ImmichCarousel()), QueueSideSheet()]);
  }
}
