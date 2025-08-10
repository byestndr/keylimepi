import 'package:flutter/material.dart';
import 'package:spotimmich/widgets/controls.dart';
import 'package:spotimmich/widgets/weatherwidget.dart';

class BottomPlaybar extends StatelessWidget {
  final Function(bool) isQueueExpanded;
  const BottomPlaybar({super.key, required this.isQueueExpanded});

  @override
  Widget build(BuildContext context) {
    final double currentScreenSize = MediaQuery.of(context).size.width;
    const double sliderWidthBreakpoint = 600;
    const double weatherWidthBreakpoint = 530;

    return BottomAppBar(
      child: Row(
        children: <Widget>[
          PlaybackControls(isExpanded: isQueueExpanded,),
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
    );
  }
}
