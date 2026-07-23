import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:key_limepi/song_select/song_select_item.dart';

class ItemViewInfoWidget extends StatelessWidget {
  final SpotifyItem item;
  const ItemViewInfoWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: .end,
      children: [
        SizedBox.square(
          dimension: 125,
          child: Hero(
            tag: key!,
            child: Material(
              clipBehavior: .antiAlias,
              borderRadius: BorderRadiusGeometry.circular(20),
              child: CachedNetworkImage(imageUrl: item.image.toString()),
            ),
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
                    item.name,
                    overflow: .ellipsis,
                    style: TextStyle(
                      fontFamily: 'Roboto Flex',
                      fontFamilyFallback: <String>['NotoSansJP'],
                      fontWeight: .w800,
                      fontSize: (MediaQuery.of(context).size.width / 15).clamp(
                        0,
                        48,
                      ),
                    ),
                  ),
                ),

                switch (item) {
                  SpotifySong song => _ArtistText(artist: song.artist),
                  SpotifyAlbum album => _ArtistText(artist: album.artist),
                  _ => const Padding(padding: .zero),
                },
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ArtistText extends StatelessWidget {
  const _ArtistText({super.key, required this.artist});

  final String artist;

  @override
  Widget build(BuildContext context) {
    return Text(
      artist,
      overflow: .ellipsis,
      style: TextStyle(
        fontFamily: 'Roboto Flex',
        fontFamilyFallback: <String>['NotoSansJP'],
        fontWeight: .w400,
        fontSize: (MediaQuery.of(context).size.width / 15).clamp(0, 18),
      ),
    );
  }
}
