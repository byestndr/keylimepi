import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotimmich/providers/settings_provider.dart';
import 'package:spotimmich/settings/preferences.dart';
import 'package:spotimmich/widgets/control/controls.dart';
import 'package:spotimmich/widgets/info/weatherwidget.dart';
import 'package:spotimmich/widgets/control/seekbar.dart';

class BottomPlaybar extends ConsumerWidget {
  const BottomPlaybar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double currentScreenSize = MediaQuery.of(context).size.width;
    const double sliderWidthBreakpoint = 600;
    const double weatherWidthBreakpoint = 530;
    final UserValues preferences = ref.watch(userSettingsProvider);

    return switch (preferences.playbackBarPosition) {
      0 => BottomAppBar(
        child: Row(
          children: <Widget>[
            const PlaybackControls(),
            currentScreenSize > sliderWidthBreakpoint
                ? const Expanded(child: ProgressSlider())
                : const Padding(
                    padding: EdgeInsetsGeometry.directional(start: 12),
                  ),

            currentScreenSize > weatherWidthBreakpoint
                ? const FittedBox(child: Weatherwidget())
                : const SizedBox.shrink(),
          ],
        ),
      ),
      1 => const Padding(padding: EdgeInsetsGeometry.zero),

      int() => const Padding(padding: EdgeInsetsGeometry.zero),
    };
  }
}
