import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:key_limepi/backend/spotify/spotify_api.dart';
import 'package:key_limepi/providers/spotify/album_provider.dart';
import 'package:key_limepi/song_select/carousel_item.dart';

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
      onTap: (int index) async {
        final List<dynamic> albums = await ref.read(
          albumProviderProvider.future,
        );
        final SpotifyUserService spotifyAPI = SpotifyUserService.create();
        await spotifyAPI.startFromContext(albums[index]['album']['uri']);
      },
      itemExtent: 200,
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
