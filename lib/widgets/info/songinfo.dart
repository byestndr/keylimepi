import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marquee/marquee.dart';
import 'package:spotimmich/providers/song_info_provider.dart';

class SongTitleInfo extends ConsumerWidget {
  const SongTitleInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Song> currentSongInfo = ref.watch(infoGetterProvider);

    return Column(
      spacing: 0.0,
      children: <Widget>[
        SizedBox(
          height: 100,
          child: Marquee(
            text: currentSongInfo.when(
              skipLoadingOnRefresh: true,
              skipLoadingOnReload: true,
              data: (Song data) {
                return data.title;
              },
              error: (Object error, StackTrace trace) {
                if (error.runtimeType == NoSuchMethodError) {
                  return 'You are not logged in...';
                }

                if (error.runtimeType == FormatException) {
                  return "Nothing currently playing...";
                } else {
                  print(error.toString());
                  return 'An error has occured...';
                }
              },
              loading: () {
                return 'Nothing currently playing...';
              },
            ),
            velocity: 50,
            blankSpace: 100,
            fadingEdgeStartFraction: .1,
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
          ),
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
        skipLoadingOnRefresh: true,
        skipLoadingOnReload: true,
        data: (Song data) {
          return data.artist;
        },
        error: (Object error, StackTrace trace) {
          if (error.runtimeType == NoSuchMethodError) {
            return 'Log into Spotify via settings';
          }

          if (error.runtimeType == FormatException) {
            return "Start playing a song to control playback";
          } else {
            print(error.toString());
            return 'Check the console log for details';
          }
        },
        loading: () => 'Start playing a song to control playback',
      ),
      style: const TextStyle(
        shadows: <Shadow>[
          Shadow(color: Colors.black26, blurRadius: 3, offset: Offset(0, 2)),
        ],
        fontSize: 26.0,
        fontWeight: FontWeight.w400,
        fontFamilyFallback: <String>['NotoSansJP'],
        fontFamily: 'RobotoFlexVariable',
        fontVariations: [FontVariation.width(25), FontVariation('GRAD', 150)],
        color: Colors.white,
      ),
      maxLines: 1,
      overflow: TextOverflow.fade,
      softWrap: false,
    );
  }
}
