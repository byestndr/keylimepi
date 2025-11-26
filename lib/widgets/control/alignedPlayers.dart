import 'package:flutter/material.dart';
import 'package:spotimmich/widgets/control/controls.dart';
import 'package:spotimmich/widgets/info/songimage.dart';
import 'package:spotimmich/widgets/info/songinfo.dart';

const int _imageBreakpoint = 360;
const double _imageRadius = 15;

class CenteredInfo extends StatelessWidget {
  final bool onPageControls;
  const CenteredInfo({super.key, required this.onPageControls});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            MediaQuery.of(context).size.width >= _imageBreakpoint
                ? Padding(
                    padding: const EdgeInsetsGeometry.all(16),
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(_imageRadius),
                        ),
                        color: Colors.transparent,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 2,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),

                      child: ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(
                          _imageRadius,
                        ),
                        child: const SongImage(imageMultiplier: 400),
                      ),
                    ),
                  )
                : const Padding(
                    padding: EdgeInsetsGeometry.directional(start: 20),
                  ),

            const SongTitleInfo(),
            const SongArtistInfo(),
            onPageControls
                ? const Padding(
                    padding: EdgeInsetsDirectional.only(
                      top: 10,
                      start: 22,
                      bottom: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      spacing: 10,
                      children: <Widget>[
                        ShuffleButton(),
                        PreviousButton(),
                        PauseButton(),
                        NextButton(),
                        RepeatButton(),
                        QueueButton(),
                      ],
                    ),
                  )
                : const Padding(padding: EdgeInsetsGeometry.zero),
          ],
        ),
      ),
    );
  }
}

class BottomLeftInfo extends StatelessWidget {
  final bool onPageControls;
  const BottomLeftInfo({super.key, required this.onPageControls});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        MediaQuery.of(context).size.width >= _imageBreakpoint
            ? Padding(
                padding: const EdgeInsetsGeometry.all(16),
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(_imageRadius),
                    ),
                    color: Colors.transparent,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 2,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),

                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(_imageRadius),
                    child: const SongImage(imageMultiplier: 125),
                  ),
                ),
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
                onPageControls
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
                            QueueButton(),
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
