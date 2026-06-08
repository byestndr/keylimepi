import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SongTile extends StatelessWidget {
  final String title;
  final String artist;
  final Duration duration;
  final String? image;
  final int? index;
  const SongTile({
    super.key,
    required this.title,
    required this.artist,
    required this.duration,
    this.image,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    final String durationAsString = duration
        .toString()
        .replaceFirst(RegExp(r'0:'), '')
        .replaceFirst(RegExp(r'\..*'), '');

    return ListTile(
      onTap: () {},
      title: Text(title),
      subtitle: Text(artist),

      leading: Row(
        mainAxisSize: .min,
        children: [
          index == null
              ? ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(4),
                  child: CachedNetworkImage(
                    imageUrl: image!,
                    height: 40,
                    width: 40,
                  ),
                )
              : Text(index.toString()),
        ],
      ),
      trailing: Text(durationAsString),
    );
  }
}
