import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotimmich/providers/background_getter.dart';
import 'package:spotimmich/settings/preferences.dart';
import 'package:spotimmich/widgets/controls.dart';
import 'package:spotimmich/widgets/weatherwidget.dart';

class BottomPlaybar extends ConsumerStatefulWidget {
  final Function(bool) isQueueExpanded;
  const BottomPlaybar({super.key, required this.isQueueExpanded});

  @override
  ConsumerState<BottomPlaybar> createState() => _BottomPlaybarState();
}

class _BottomPlaybarState extends ConsumerState<BottomPlaybar> {
  Future<void> getPlaybackBarState() async {
    final int? barState = await AsyncPreferences().getIntValue(
      'playback_bar_position',
    );
    if (barState == null) {
      ref.read(barPositionProvider.notifier).changeCurrentPosition(0);
    } else {
      ref.read(barPositionProvider.notifier).changeCurrentPosition(barState);
    }

    return;
  }

  @override
  void initState() {
    super.initState();
    getPlaybackBarState();
  }

  @override
  Widget build(BuildContext context) {
    final double currentScreenSize = MediaQuery.of(context).size.width;
    const double sliderWidthBreakpoint = 600;
    const double weatherWidthBreakpoint = 530;
    final int barPositionState = ref.watch(barPositionProvider);

    return switch (barPositionState) {
      0 => BottomAppBar(
        child: Row(
          children: <Widget>[
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
