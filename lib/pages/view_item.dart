import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chopper/src/response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:key_limepi/providers/spotify/get_info_provider.dart';
import 'package:key_limepi/providers/theme/colorscheme.dart';

class ViewItem extends ConsumerWidget {
  final String id;
  final String name;
  final String? artist;
  final String image;
  const ViewItem({
    super.key,
    required this.id,
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
      getPlaylistItemsProvider(id: id, isPlaylist: isPlaylist),
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
          onPressed: () {},
          tooltip: 'Play',
          child: const Icon(Icons.play_arrow),
        ),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              flexibleSpace: Stack(
                fit: .passthrough,
                children: [
                  CachedNetworkImage(
                    imageUrl: image,
                    fit: .cover,
                    color: Colors.black.withAlpha(100),
                    colorBlendMode: .darken,
                  ),
                  ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                      child: Container(color: Colors.transparent),
                    ),
                  ),

                  Align(
                    alignment: .bottomStart,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        crossAxisAlignment: .end,
                        children: [
                          SizedBox.square(
                            dimension: MediaQuery.of(context).size.height / 3,
                            child: ClipRRect(
                              borderRadius: BorderRadiusGeometry.circular(12),
                              child: CachedNetworkImage(imageUrl: image),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Column(
                                crossAxisAlignment: .start,
                                mainAxisAlignment: .end,
                                children: [
                                  Transform.translate(
                                    offset: const Offset(0, 4),
                                    child: Text(
                                      name,
                                      overflow: .ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'Roboto Flex',
                                        fontFamilyFallback: <String>[
                                          'NotoSansJP',
                                        ],
                                        fontWeight: .w800,
                                        fontSize:
                                            (MediaQuery.of(context).size.width /
                                                    15)
                                                .clamp(0, 48),
                                      ),
                                    ),
                                  ),
                                  !isPlaylist
                                      ? Text(
                                          "$artist",
                                          overflow: .ellipsis,
                                          style: TextStyle(
                                            fontFamily: 'Roboto Flex',
                                            fontFamilyFallback: <String>[
                                              'NotoSansJP',
                                            ],
                                            fontWeight: .w400,
                                            fontSize:
                                                (MediaQuery.of(
                                                          context,
                                                        ).size.width /
                                                        15)
                                                    .clamp(0, 18),
                                          ),
                                        )
                                      : const Padding(padding: .zero),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              expandedHeight: MediaQuery.of(context).size.height / 1.5,
            ),

            songs.when(
              data: (Response<dynamic> data) {
                return SliverList.builder(
                  itemCount: (data.body['items'] as List<dynamic>).length,
                  itemBuilder: (BuildContext context, int index) => ListTile(
                    title: Text(
                      isPlaylist
                          ? data.body['items'][index]['item']['name']
                          : data.body['items'][index]['name'],
                    ),
                  ),
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
