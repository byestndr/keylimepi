import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:key_limepi/providers/spotify/playlists_provider.dart';
import 'package:key_limepi/song_select/widget/carousel_item.dart';

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
      enableSplash: false,
      itemExtent: 150,
      itemSnapping: true,
      children: List<Widget>.generate(
        playlists.when(
          data: (List data) => data.length,
          error: (Object error, StackTrace stack) => 1,
          loading: () => 1,
        ),
        (int index) => playlists.when(
          data: (List data) {
            return CarouselItem(
              title: data[index]['name'],
              image: data[index]['images'][0]['url'],
              id: data[index]['id'],
              uri: data[index]['uri'],
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
