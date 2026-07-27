import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:key_limepi/song_select/song_select_item.dart';
import 'package:marquee/marquee.dart';
import 'package:key_limepi/providers/spotify/song_info_provider.dart';

class SongTitleInfo extends ConsumerWidget {
  const SongTitleInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<SpotifySong?> currentSongInfo = ref.watch(
      infoGetterProvider,
    );

    return Column(
      spacing: 0.0,
      children: <Widget>[
        SizedBox(
          height: 100,
          child: Marquee(
            text: currentSongInfo.when(
              skipLoadingOnRefresh: true,
              skipLoadingOnReload: true,
              data: (SpotifySong? data) {
                return data?.name ?? "Nothing currently playing...";
              },
              error: (Object error, StackTrace trace) {
                if (error.runtimeType == NoSuchMethodError) {
                  return 'Media type not supported';
                }

                if (error.runtimeType == FormatException) {
                  return "Nothing currently playing...";
                } else {
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
    final AsyncValue<SpotifySong?> currentSongInfo = ref.watch(
      infoGetterProvider,
    );

    return Text(
      currentSongInfo.when(
        skipLoadingOnRefresh: true,
        skipLoadingOnReload: true,
        data: (SpotifySong? data) {
          return data?.artist ?? "Start playing a song to control playback";
        },
        error: (Object error, StackTrace trace) {
          if (error.runtimeType == NoSuchMethodError) {
            return 'Play something else to view info';
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
