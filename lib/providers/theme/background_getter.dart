import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'background_getter.g.dart';

@riverpod
class BackgroundOpacity extends _$BackgroundOpacity {
  @override
  int build() {
    return 5;
  }

  void setOpacity(int opacity) {
    if (opacity > 255) {
      state = 255;
    }

    state = opacity;
    return;
  }
}