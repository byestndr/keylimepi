import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ItemViewInfoWidget extends StatelessWidget {
  const ItemViewInfoWidget({
    super.key,
    required this.image,
    required this.name,
    required this.isPlaylist,
    required this.artist,
  });

  final String image;
  final String name;
  final bool isPlaylist;
  final String? artist;

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
              child: CachedNetworkImage(imageUrl: image),
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
                    name,
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
                !isPlaylist
                    ? Text(
                        "$artist",
                        overflow: .ellipsis,
                        style: TextStyle(
                          fontFamily: 'Roboto Flex',
                          fontFamilyFallback: <String>['NotoSansJP'],
                          fontWeight: .w400,
                          fontSize: (MediaQuery.of(context).size.width / 15)
                              .clamp(0, 18),
                        ),
                      )
                    : const Padding(padding: .zero),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
