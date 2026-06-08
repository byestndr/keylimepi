import 'package:chopper/src/response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:key_limepi/backend/spotify/spotify_api.dart';
import 'package:key_limepi/providers/spotify/get_info_provider.dart';
import 'package:key_limepi/providers/theme/colorscheme.dart';
import 'package:key_limepi/song_select/widget/song_tile.dart';
import 'package:key_limepi/view_item_header.dart';

class ViewItem extends ConsumerWidget {
  final String id;
  final String uri;
  final String name;
  final String? artist;
  final String image;
  const ViewItem({
    super.key,
    required this.id,
    required this.uri,
    required this.name,
    required this.image,
    this.artist,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isPlaylist = artist == null;
    final AsyncValue<ColorScheme> itemColorscheme = ref.read(
      generateColorSchemeProvider(image),
    );
    final AsyncValue<Response<dynamic>> songs = ref.read(
      getSongItemsProvider(id: id, isPlaylist: isPlaylist),
    );

    return Theme(
      data: ThemeData.from(
        colorScheme: itemColorscheme.when(
          data: (ColorScheme data) => data,
          error: (Object error, StackTrace stackTrace) =>
              Theme.of(context).colorScheme,
          loading: () => Theme.of(context).colorScheme,
          skipError: true,
          skipLoadingOnRefresh: true,
          skipLoadingOnReload: true,
        ),
      ),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final SpotifyUserService spotifyAPI = SpotifyUserService.create();
            spotifyAPI.startFromContext(uri);
          },
          tooltip: 'Play',
          child: const Icon(Icons.play_arrow),
        ),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height / 1.5,
              pinned: true,
              titleSpacing: 0,
              title: Row(
                spacing: 5,
                children: [
                  Icon(isPlaylist ? Icons.playlist_play_rounded : Icons.album),
                  Expanded(child: Text(name, overflow: .fade)),
                ],
              ),
              flexibleSpace: ViewItemHeader(
                image: image,
                name: name,
                isPlaylist: isPlaylist,
                artist: artist,
              ),
            ),

            songs.when(
              data: (Response<dynamic> data) {
                return SliverList.builder(
                  itemCount: (data.body['items'] as List<dynamic>).length,
                  itemBuilder: (BuildContext context, int index) {
                    List<String> artists = [];
                    if (isPlaylist) {
                      final List<dynamic> artistList =
                          data.body['items'][index]['item']['artists'];

                      for (final Map<String, dynamic> artist in artistList) {
                        artists.add(artist['name']);
                      }
                    } else {
                      final List<dynamic> artistList =
                          data.body['items'][index]['artists'];
                      for (final Map<String, dynamic> artist in artistList) {
                        artists.add(artist['name']);
                      }
                    }

                    return SongTile(
                      title: isPlaylist
                          ? data.body['items'][index]['item']['name']
                          : data.body['items'][index]['name'],
                      artist: (artists.toString()).replaceAll(
                        RegExp(r'\[|\]'),
                        '',
                      ),
                      duration: Duration(
                        milliseconds: isPlaylist
                            ? data.body['items'][index]['item']['duration_ms']
                            : data.body['items'][index]['duration_ms'],
                      ),
                      image:
                          (data.body['items'][index]['item']['album']['images']
                                  as List<dynamic>)
                              .last['url'],
                      index: index,
                    );
                  },
                );
              },
              error: (Object error, StackTrace stackTrace) =>
                  const SliverToBoxAdapter(
                    child: Text('There was an error fetching songs.'),
                  ),
              loading: () =>
                  const SliverToBoxAdapter(child: LinearProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }
}
