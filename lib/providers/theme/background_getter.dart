import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spotimmich/settings/immich/immichpreferences.dart';

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