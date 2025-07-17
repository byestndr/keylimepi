import 'package:flutter/material.dart';
import 'package:spotimmich/controls.dart';
import 'package:spotimmich/weatherwidget.dart';

class BottomPlaybar extends StatelessWidget {
  const BottomPlaybar({super.key});

  @override
  Widget build(BuildContext context) {
    final double currentScreenSize = MediaQuery.of(context).size.width;
    final double playbarWidthBreakpoint = 600;

    return BottomAppBar(
      
      child: Row(
        children: <Widget>[
          const PlaybackControls(),
          currentScreenSize > playbarWidthBreakpoint
              ? const Expanded(child: ProgressSlider())
              : const Padding(padding: EdgeInsetsGeometry.directional(start: 12)),
          const FittedBox(child: Weatherwidget()),
        ],
      ),
    );
  }
}
