import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:key_limepi/song_select/widget/item_info_widget.dart';

class ViewItemHeader extends StatelessWidget {
  const ViewItemHeader({
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
    return FlexibleSpaceBar(
      collapseMode: .pin,
      background: Stack(
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
              child: ItemViewInfoWidget(
                key: key,
                image: image,
                name: name,
                isPlaylist: isPlaylist,
                artist: artist,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
