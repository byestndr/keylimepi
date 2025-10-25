import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotimmich/widgets/carousels/album_carousel.dart';
import 'package:spotimmich/widgets/carousels/liked_songs.dart';
import 'package:spotimmich/player_page.dart';
import 'package:spotimmich/widgets/carousels/playlist_carousel.dart';
import 'package:spotimmich/providers/album_provider.dart';
import 'package:spotimmich/providers/likedSongs_provider.dart';
import 'package:spotimmich/providers/playlists_provider.dart';
import 'package:spotimmich/widgets/songimage.dart';
import 'package:spotimmich/widgets/songinfo.dart';

class SongSelect extends ConsumerStatefulWidget {
  const SongSelect({super.key});

  @override
  ConsumerState<SongSelect> createState() => _SongSelectState();
}

class _SongSelectState extends ConsumerState<SongSelect> {
  static const double imageRadius = 28;

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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                        borderRadius:
                                            BorderRadiusGeometry.circular(
                                              imageRadius,
                                            ),
                                        child: const SongImage(
                                          imageMultiplier: 200,
                                        ),
                                      ),
                                    ),
                                  )
                                : const Padding(
                                    padding: EdgeInsetsGeometry.directional(
                                      start: 20,
                                    ),
                                  ),
                            const Expanded(
                              child: Padding(
                                padding: EdgeInsetsGeometry.directional(bottom: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const SongTitleInfo(),
                                    const SongArtistInfo(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
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
              const SizedBox(height: 200, child: PlaylistCarousel()),
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
              const SizedBox(height: 200, child: AlbumCarousel()),
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
              const SizedBox(height: 200, child: SongCarousel()),
            ],
          ),
          onRefresh: () async {
            final Future<void> refreshAlbums = ref
                .read(albumProviderProvider.notifier)
                .refreshAlbums();
            final Future<void> refreshSongs = ref
                .read(songProviderProvider.notifier)
                .refreshSongs();
            final Future<void> refreshPlaylists = ref
                .read(playlistsProviderProvider.notifier)
                .refreshPlaylists();

            await Future.wait(<Future<void>>[
              refreshAlbums,
              refreshSongs,
              refreshPlaylists,
            ]);
          },
        ),
      ),
    );
  }
}
