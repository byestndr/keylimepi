import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotimmich/providers/album_art_provider.dart';
import 'package:spotimmich/providers/colorscheme.dart';
import 'package:spotimmich/providers/song_info_provider.dart';

class SongTitleInfo extends ConsumerWidget {
  const SongTitleInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Song> currentSongInfo = ref.watch(infoGetterProvider);

    return Column(
      spacing: 0.0,
      children: <Widget>[
        Text(
          currentSongInfo.when(
            data: (Song data) {
              if (data.title == null) {
                return 'Nothing currently playing...';
              } else {
                Future.microtask(() {
                  ref.read(oldSongProvider.notifier).setOldSong(oldSong: data);
                });

                return data.title!;
              }
            },
            error: (Object error, StackTrace trace) {
              if (error.toString().contains('FormatException')) {
                return "Nothing currently playing...";
              } else {
                return error.toString();
              }
            },
            loading: () {
              return ref.read(oldSongProvider).title;
            },
          ),
          style: const TextStyle(
            shadows: <Shadow>[
              Shadow(
                color: Colors.black26,
                blurRadius: 3,
                offset: Offset(0, 2),
              ),
            ],
            fontSize: 64.0,
            fontWeight: FontWeight.w900,
            fontFamilyFallback: <String>['NotoSansJP'],
            fontFamily: 'RobotoFlexVariable',
            fontVariations: [
              FontVariation.width(110),
              FontVariation.weight(900),
              FontVariation('GRAD', 150),
            ],
            color: Colors.white,
          ),
          maxLines: 1,
          overflow: TextOverflow.fade,
          softWrap: false,
        ),
      ],
    );
  }
}

class SongArtistInfo extends ConsumerWidget {
  const SongArtistInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Song> currentSongInfo = ref.watch(infoGetterProvider);

    return Text(
      currentSongInfo.when(
        data: (Song data) {
          if (data.title == null) {
            return "Start playing a song to control playback";
          } else {
            return data.artist!;
          }
        },
        error: (Object error, StackTrace trace) {
          if (error.toString().contains('FormatException')) {
            return "Start playing a song to control playback";
          } else {
            return error.toString();
          }
        },
        loading: () => ref.read(oldSongProvider).artist,
      ),
      style: const TextStyle(
        shadows: <Shadow>[
          Shadow(color: Colors.black26, blurRadius: 3, offset: Offset(0, 2)),
        ],
        fontSize: 26.0,
        fontWeight: FontWeight.w400,
        fontFamilyFallback: <String>['NotoSansJP'],
        fontFamily: 'RobotoFlexVariable',
        fontVariations: [
          FontVariation.width(25),
          FontVariation('GRAD', 150),
        ],
        color: Colors.white,
      ),
      maxLines: 1,
      overflow: TextOverflow.fade,
      softWrap: false,
    );
  }
}
