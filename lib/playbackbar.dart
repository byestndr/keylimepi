import 'package:flutter/material.dart';
import 'package:spotimmich/controls.dart';
import 'package:spotimmich/weatherwidget.dart';

class BottomPlaybar extends StatelessWidget {
  const BottomPlaybar({super.key});

  @override
  Widget build(BuildContext context) {
    final double currentScreenSize = MediaQuery.of(context).size.width;
    const double sliderWidthBreakpoint = 600;
    const double weatherWidthBreakpoint = 530;

    return BottomAppBar(
      
      child: Row(
        children: <Widget>[
          const PlaybackControls(),
          currentScreenSize > sliderWidthBreakpoint
              ? const Expanded(child: ProgressSlider())
              : const Padding(padding: EdgeInsetsGeometry.directional(start: 12)),
          currentScreenSize > weatherWidthBreakpoint
              ? const FittedBox(child: Weatherwidget())
              : const SizedBox.shrink()
          
        ],
      ),
    );
  }
}
