import 'package:chopper/src/response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spotimmich/providers/spotify/spotify_playbackstate.dart';

part 'seekbar_provider.g.dart';

@Riverpod(keepAlive: true)
class SeekbarPosition extends _$SeekbarPosition {
  @override
  double build() {
    return 0;
  }

  void setSliderPos(double position) {
    state = position;
    return;
  }
}
