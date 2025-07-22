import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:spotimmich/album_carousel.dart';
import 'package:spotimmich/liked_songs.dart';
import 'package:spotimmich/player_page.dart';
import 'package:spotimmich/playlist_carousel.dart';
import 'package:spotimmich/widgets/songimage.dart';

class SongSelect extends StatefulWidget {
  const SongSelect({super.key});

  @override
  State<SongSelect> createState() => _SongSelectState();
}

class _SongSelectState extends State<SongSelect> {
  bool refreshing = false;

  Future<void> refreshChildren() async {
    setState(() {
      refreshing = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.all(6),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
        ),
        child: RefreshIndicator(
          child: ListView(
            addAutomaticKeepAlives: true,
            children: <Widget>[
              SizedBox(
                height: 400,
                child: CarouselView.weighted(
                  flexWeights: <int>[2],
                  children: <Widget>[
                    Stack(
                      fit: StackFit.passthrough,
                      children: <Widget>[
                        ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return const LinearGradient(
                              begin: FractionalOffset.centerLeft,
                              end: FractionalOffset.centerRight,
                              colors: <Color>[Colors.black12, Colors.black87],
                            ).createShader(bounds);
                          },
                          blendMode: BlendMode.dstIn,
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: ImageFiltered(
                              imageFilter: ImageFilter.blur(
                                sigmaX: 10,
                                sigmaY: 10,
                              ),
                              child: const SongImage(imageMultiplier: 200),
                            ),
                          ),
                        ),
                        MediaWidget(),
                      ],
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Your Playlists',
                  style: TextStyle(
                    fontFamily: 'Roboto Flex',
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(
                height: 200,
                child: PlaylistCarousel(refresh: refreshing),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Saved Albums',
                  style: TextStyle(
                    fontFamily: 'Roboto Flex',
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 200, child: AlbumCarousel(refresh: refreshing)),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Liked Songs',
                  style: TextStyle(
                    fontFamily: 'Roboto Flex',
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 200, child: SongCarousel(refresh: refreshing)),
            ],
          ),
          onRefresh: () async {
            return refreshChildren();
          },
        ),
      ),
    );
  }
}
