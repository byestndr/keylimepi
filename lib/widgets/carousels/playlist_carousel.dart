import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:key_limepi/backend/spotify/spotify_api.dart';
import 'package:key_limepi/providers/spotify/playlists_provider.dart';

class PlaylistCarousel extends ConsumerStatefulWidget {
  const PlaylistCarousel({super.key});

  @override
  ConsumerState<PlaylistCarousel> createState() => _PlaylistCarouselState();
}

class _PlaylistCarouselState extends ConsumerState<PlaylistCarousel> {
  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<dynamic>> playlists = ref.watch(
      playlistsProviderProvider,
    );

    return CarouselView(
      onTap: (int index) async {
        final List<dynamic> playlists = await ref.read(
          playlistsProviderProvider.future,
        );
        final SpotifyUserService spotifyAPI = SpotifyUserService.create();
        await spotifyAPI.startFromContext(playlists[index]['uri']);
      },
      itemExtent: 200,
      children: List<Widget>.generate(
        playlists.when(
          data: (List data) => data.length,
          error: (Object error, StackTrace stack) => 1,
          loading: () => 1,
        ),
        (int index) => playlists.when(
          data: (List data) {
            return Stack(
              fit: StackFit.passthrough,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsetsGeometry.directional(
                    top: 155,
                    start: 15,
                  ),
                  child: Text(
                    data[index]['name'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    softWrap: false,
                  ),
                ),
                FittedBox(
                  fit: BoxFit.cover,
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                        begin: FractionalOffset.topCenter,
                        end: FractionalOffset.bottomCenter,
                        colors: <Color>[Colors.black12, Colors.black],
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.dstOut,
                    child: CachedNetworkImage(
                      imageUrl: data[index]['images'][0]['url'],
                      fadeInCurve: const Cubic(0.05, 0.7, 0.1, 1.0),
                      fadeInDuration: const Duration(milliseconds: 400),
                      fadeOutCurve: const Cubic(0.3, 0.0, 0.8, 0.15),
                      fadeOutDuration: const Duration(milliseconds: 200),
                    ),
                  ),
                ),
              ],
            );
          },
          error: (Object error, StackTrace stack) {
            return const Center(child: CircularProgressIndicator());
          },
          loading: () {
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
