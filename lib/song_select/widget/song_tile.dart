import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:key_limepi/backend/spotify/spotify_api.dart';

class SongTile extends StatelessWidget {
  final String title;
  final String artist;
  final Duration duration;
  final String? image;
  final int? index;
  final String playlistID;
  final String songID;
  const SongTile({
    super.key,
    required this.title,
    required this.artist,
    required this.duration,
    required this.playlistID,
    required this.songID,
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
      onTap: () {
        final SpotifyUserService spotifyAPI = SpotifyUserService.create();
        spotifyAPI.startFromContext(
          contextUri: playlistID,
          offsetTrack: songID,
        );
      },
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Roboto Flex',
          fontFamilyFallback: <String>['NotoSansJP'],
        ),
      ),
      subtitle: Text(
        artist,
        style: const TextStyle(
          fontFamily: 'Roboto Flex',
          fontFamilyFallback: <String>['NotoSansJP'],
        ),
      ),

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
              : Text(
                  index.toString(),
                  style: const TextStyle(
                    fontFamily: 'Roboto Flex',
                    fontFamilyFallback: <String>['NotoSansJP'],
                  ),
                ),
        ],
      ),
      trailing: Text(durationAsString),
    );
  }
}
