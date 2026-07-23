import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:key_limepi/backend/spotify/spotify_api.dart';
import 'package:key_limepi/song_select/song_select_item.dart';

class SongTile extends StatelessWidget {
  final SpotifySong song;
  final SpotifyCollection collection;
  final int? index;

  const SongTile({
    super.key,
    required this.song,
    required this.collection,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    final String durationAsString = song.duration
        .toString()
        .replaceFirst(RegExp(r'0:'), '')
        .replaceFirst(RegExp(r'\..*'), '');

    return ListTile(
      onTap: () {
        final SpotifyUserService spotifyAPI = SpotifyUserService.create();
        spotifyAPI.startFromContext(
          contextUri: collection.uri,
          offsetTrack: song.uri,
        );
      },
      title: Text(
        song.name,
        style: const TextStyle(
          fontFamily: 'Roboto Flex',
          fontFamilyFallback: <String>['NotoSansJP'],
        ),
      ),
      subtitle: Text(
        song.artist,
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
                    imageUrl: song.image.toString(),
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
