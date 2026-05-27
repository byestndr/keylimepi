import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:key_limepi/settings/immich/immichpreferences.dart';

part 'background_getter.g.dart';

@riverpod
class Background1 extends _$Background1 {
  @override
  Future<Image> build({required double pixelRatio}) async {
    final Image image = await getBackgroundImage(pixelRatio);
    return image;
  }

  void refreshImage() {
    ref.invalidateSelf();
  }
}

@riverpod
class Background2 extends _$Background1 {
  @override
  Future<Image> build({required double pixelRatio}) async {
    final Image image = await getBackgroundImage(pixelRatio);
    return image;
  }

  void refreshImage() {
    ref.invalidateSelf();
  }
}

@riverpod
class Background3 extends _$Background1 {
  @override
  Future<Image> build({required double pixelRatio}) async {
    final Image image = await getBackgroundImage(pixelRatio);
    return image;
  }

  void refreshImage() {
    ref.invalidateSelf();
  }
}

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