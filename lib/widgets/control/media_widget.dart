import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:key_limepi/providers/settings_provider.dart';
import 'package:key_limepi/settings/preferences_backend.dart';
import 'package:key_limepi/widgets/control/controls.dart';
import 'package:key_limepi/widgets/info/songimage.dart';
import 'package:key_limepi/widgets/info/songinfo.dart';

const int _imageBreakpoint = 360;

class MediaWidget extends ConsumerWidget {
  const MediaWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserValues preferences = ref.watch(userSettingsProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        MediaQuery.of(context).size.width >= _imageBreakpoint
            ? const Padding(
                padding: EdgeInsetsGeometry.all(16),
                child: SongImage(),
              )
            : const Padding(padding: EdgeInsetsGeometry.directional(start: 20)),
        Expanded(
          child: Padding(
            padding: const EdgeInsetsGeometry.directional(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SongTitleInfo(),
                const SongArtistInfo(),
                preferences.playbackBarPosition == 1
                    ? const Padding(
                        padding: EdgeInsetsDirectional.only(
                          top: 10,
                          start: 0,
                          bottom: 3,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          spacing: 5,
                          children: <Widget>[
                            ShuffleButton(),
                            PreviousButton(),
                            PauseButton(),
                            NextButton(),
                            RepeatButton(),
                          ],
                        ),
                      )
                    : const Padding(padding: EdgeInsetsGeometry.zero),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
