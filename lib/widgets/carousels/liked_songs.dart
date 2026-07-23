import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:key_limepi/providers/spotify/likedSongs_provider.dart';
import 'package:key_limepi/song_select/song_select_item.dart';
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
              item: SpotifySong(
                name: data[index]['track']['name'],
                id: data[index]['track']['id'],
                uri: data[index]['track']['uri'],
                image: Uri.parse(data[index]['track']['album']['images'][0]['url']),
                artist: data[index]['track']['album']['artists'][0]['name'],
                duration: Duration(milliseconds: data[index]['track']['duration_ms']),
              ),
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
