import 'package:flutter/material.dart';
import 'package:spotimmich/widgets/songimage.dart';
import 'package:spotimmich/widgets/songinfo.dart';

const int _imageBreakpoint = 360;
const double _imageRadius = 15;

class CenteredInfo extends StatelessWidget {
  const CenteredInfo({super.key});

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
          ],
        ),
      ),
    );
  }
}

class BottomLeftInfo extends StatelessWidget {
  const BottomLeftInfo({super.key});

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
        const Expanded(
          child: Padding(
            padding: EdgeInsetsGeometry.directional(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [const SongTitleInfo(), const SongArtistInfo()],
            ),
          ),
        ),
      ],
    );
  }
}
