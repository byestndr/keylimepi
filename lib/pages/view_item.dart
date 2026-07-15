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
    final AsyncValue<List<dynamic>> songs = ref.read(
      getItemSongsProvider(id: id, isPlaylist: isPlaylist),
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
            spotifyAPI.startFromContext(contextUri: uri);
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
                key: key,
                image: image,
                name: name,
                isPlaylist: isPlaylist,
                artist: artist,
              ),
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
                      title: isPlaylist
                          ? data[index]['item']['name']
                          : data[index]['name'],
                      artist: (artists.toString()).replaceAll(
                        RegExp(r'\[|\]'),
                        '',
                      ),
                      duration: Duration(
                        milliseconds: isPlaylist
                            ? data[index]['item']['duration_ms']
                            : data[index]['duration_ms'],
                      ),
                      image: isPlaylist
                          ? (data[index]['item']['album']['images']
                                    as List<dynamic>)
                                .last['url']
                          : null,
                      index: isPlaylist ? null : index + 1,
                      songID: isPlaylist
                          ? data[index]['item']['uri']
                          : data[index]['uri'],
                      playlistID: uri,
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
