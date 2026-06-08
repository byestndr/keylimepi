import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:key_limepi/providers/spotify/album_provider.dart';
import 'package:key_limepi/song_select/widget/carousel_item.dart';

class AlbumCarousel extends ConsumerStatefulWidget {
  const AlbumCarousel({super.key});

  @override
  ConsumerState<AlbumCarousel> createState() => _AlbumCarouselState();
}

class _AlbumCarouselState extends ConsumerState<AlbumCarousel> {
  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<dynamic>> albumList = ref.watch(
      albumProviderProvider,
    );

    return CarouselView(
      enableSplash: false,
      itemExtent: 150,
      itemSnapping: true,
      children: List<Widget>.generate(
        albumList.when(
          data: (List data) => data.length,
          error: (Object error, StackTrace stack) => 1,
          loading: () => 1,
        ),
        (int index) => albumList.when(
          data: (List data) {
            return CarouselItem(
              title: data[index]['album']['name'],
              artist: data[index]['album']['artists'][0]['name'],
              image: data[index]['album']['images'][0]['url'],
              id: data[index]['album']['uri'],
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
