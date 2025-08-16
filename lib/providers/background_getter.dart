import 'dart:math';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spotimmich/settings/immich/immichpreferences.dart';

part 'background_getter.g.dart';

@riverpod
class background1 extends _$background1 {
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
class background2 extends _$background1 {
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
class background3 extends _$background1 {
  @override
  Future<Image> build({required double pixelRatio}) async {
    final Image image = await getBackgroundImage(pixelRatio);
    return image;
  }

  void refreshImage() {
    ref.invalidateSelf();
  }
}
