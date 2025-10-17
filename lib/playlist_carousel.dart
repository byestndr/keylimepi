import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotimmich/providers/playlists_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class PlaylistCarousel extends ConsumerStatefulWidget {
  final bool refresh;
  const PlaylistCarousel({super.key, required this.refresh});

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
        await ref.read(playlistsProviderProvider.notifier).startPlaylist(index);
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
                    child: Image.network(data[index]['images'][0]['url']),
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
