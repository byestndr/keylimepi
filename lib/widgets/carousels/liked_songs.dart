import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:key_limepi/providers/spotify/likedSongs_provider.dart';
import 'package:key_limepi/song_select/widget/carousel_item.dart';

class SongCarousel extends ConsumerStatefulWidget {
  const SongCarousel({super.key});

  @override
  ConsumerState<SongCarousel> createState() => _AlbumCarouselState();
}

class _AlbumCarouselState extends ConsumerState<SongCarousel> {
  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<dynamic>> songList = ref.watch(songProviderProvider);

    return CarouselView(
      enableSplash: false,
      itemExtent: 150,
      itemSnapping: true,
      children: List<Widget>.generate(
        songList.when(
          data: (List data) => data.length,
          error: (Object error, StackTrace stack) => 1,
          loading: () => 1,
        ),
        (int index) => songList.when(
          data: (List data) {
            return CarouselItem(
              title: data[index]['track']['name'],
              artist: data[index]['track']['album']['artists'][0]['name'],
              image: data[index]['track']['album']['images'][0]['url'],
              id: data[index]['track']['uri'],
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
