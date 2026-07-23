import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:key_limepi/backend/spotify/spotify_api.dart';
import 'package:key_limepi/providers/spotify/get_info_provider.dart';
import 'package:key_limepi/providers/theme/colorscheme.dart';
import 'package:key_limepi/song_select/song_select_item.dart';
import 'package:key_limepi/song_select/widget/song_tile.dart';
import 'package:key_limepi/song_select/widget/view_item_header.dart';

class ViewItem extends ConsumerWidget {
  final SpotifyCollection item;

  const ViewItem({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isPlaylist = item is SpotifyPlaylist;

    final AsyncValue<ColorScheme> itemColorscheme = ref.read(
      generateColorSchemeProvider(item.image.toString()),
    );
    final AsyncValue<List<dynamic>> songs = ref.read(
      getItemSongsProvider(id: item.id, isPlaylist: isPlaylist),
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
            spotifyAPI.startFromContext(contextUri: item.uri);
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
                  Expanded(child: Text(item.name, overflow: .fade)),
                ],
              ),
              flexibleSpace: ViewItemHeader(key: key, item: item),
            ),

            songs.when(
              data: (List<dynamic> data) {
                return SliverList.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    List<String> artists = [];
                    if (isPlaylist) {
                      final List<dynamic> artistList =
                          data[index]['item']['artists'];

                      for (final Map<String, dynamic> artist in artistList) {
                        artists.add(artist['name']);
                      }
                    } else {
                      final List<dynamic> artistList = data[index]['artists'];
                      for (final Map<String, dynamic> artist in artistList) {
                        artists.add(artist['name']);
                      }
                    }

                    return SongTile(
                      song: SpotifySong(
                        name: isPlaylist
                            ? data[index]['item']['name']
                            : data[index]['name'],
                        id: isPlaylist
                            ? data[index]['item']['id']
                            : data[index]['id'],
                        uri: isPlaylist
                            ? data[index]['item']['uri']
                            : data[index]['uri'],
                        image: isPlaylist
                            ? Uri.tryParse(
                                    (data[index]['item']['album']['images']
                                            as List<dynamic>)
                                        .last['url'],
                                  ) ??
                                  Uri()
                            : item.image,
                        artist: (artists.toString()).replaceAll(
                          RegExp(r'\[|\]'),
                          '',
                        ),
                        duration: Duration(
                          milliseconds: isPlaylist
                              ? data[index]['item']['duration_ms']
                              : data[index]['duration_ms'],
                        ),
                      ),

                      index: isPlaylist ? null : index + 1,
                      collection: item,
                    );
                  },
                );
              },
              error: (Object error, StackTrace stackTrace) {
                return const SliverToBoxAdapter(
                  child: Text('There was an error fetching songs.'),
                );
              },

              loading: () =>
                  const SliverToBoxAdapter(child: LinearProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }
}
