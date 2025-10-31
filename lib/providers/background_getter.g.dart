// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'background_getter.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(background1)
const background1Provider = Background1Family._();

final class Background1Provider
    extends $AsyncNotifierProvider<background1, Image> {
  const Background1Provider._({
    required Background1Family super.from,
    required double super.argument,
  }) : super(
         retry: null,
         name: r'background1Provider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$background1Hash();

  @override
  String toString() {
    return r'background1Provider'
        ''
        '($argument)';
  }

  @$internal
  @override
  background1 create() => background1();

  @override
  bool operator ==(Object other) {
    return other is Background1Provider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$background1Hash() => r'1ba6334e085ec519f45537203a102b3b39dc398b';

final class Background1Family extends $Family
    with
        $ClassFamilyOverride<
          background1,
          AsyncValue<Image>,
          Image,
          FutureOr<Image>,
          double
        > {
  const Background1Family._()
    : super(
        retry: null,
        name: r'background1Provider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  Background1Provider call({required double pixelRatio}) =>
      Background1Provider._(argument: pixelRatio, from: this);

  @override
  String toString() => r'background1Provider';
}

abstract class _$background1 extends $AsyncNotifier<Image> {
  late final _$args = ref.$arg as double;
  double get pixelRatio => _$args;

  FutureOr<Image> build({required double pixelRatio});
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(pixelRatio: _$args);
    final ref = this.ref as $Ref<AsyncValue<Image>, Image>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Image>, Image>,
              AsyncValue<Image>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(background2)
const background2Provider = Background2Family._();

final class Background2Provider
    extends $AsyncNotifierProvider<background2, Image> {
  const Background2Provider._({
    required Background2Family super.from,
    required double super.argument,
  }) : super(
         retry: null,
         name: r'background2Provider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$background2Hash();

  @override
  String toString() {
    return r'background2Provider'
        ''
        '($argument)';
  }

  @$internal
  @override
  background2 create() => background2();

  @override
  bool operator ==(Object other) {
    return other is Background2Provider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$background2Hash() => r'17b5d60f473199b6311a6e9137f093d744f21568';

final class Background2Family extends $Family
    with
        $ClassFamilyOverride<
          background2,
          AsyncValue<Image>,
          Image,
          FutureOr<Image>,
          double
        > {
  const Background2Family._()
    : super(
        retry: null,
        name: r'background2Provider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  Background2Provider call({required double pixelRatio}) =>
      Background2Provider._(argument: pixelRatio, from: this);

  @override
  String toString() => r'background2Provider';
}

abstract class _$background2 extends $AsyncNotifier<Image> {
  late final _$args = ref.$arg as double;
  double get pixelRatio => _$args;

  FutureOr<Image> build({required double pixelRatio});
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(pixelRatio: _$args);
    final ref = this.ref as $Ref<AsyncValue<Image>, Image>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Image>, Image>,
              AsyncValue<Image>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(background3)
const background3Provider = Background3Family._();

final class Background3Provider
    extends $AsyncNotifierProvider<background3, Image> {
  const Background3Provider._({
    required Background3Family super.from,
    required double super.argument,
  }) : super(
         retry: null,
         name: r'background3Provider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$background3Hash();

  @override
  String toString() {
    return r'background3Provider'
        ''
        '($argument)';
  }

  @$internal
  @override
  background3 create() => background3();

  @override
  bool operator ==(Object other) {
    return other is Background3Provider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$background3Hash() => r'928a89b9127060c0b0029c22895fe65359f55c2e';

final class Background3Family extends $Family
    with
        $ClassFamilyOverride<
          background3,
          AsyncValue<Image>,
          Image,
          FutureOr<Image>,
          double
        > {
  const Background3Family._()
    : super(
        retry: null,
        name: r'background3Provider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  Background3Provider call({required double pixelRatio}) =>
      Background3Provider._(argument: pixelRatio, from: this);

  @override
  String toString() => r'background3Provider';
}

abstract class _$background3 extends $AsyncNotifier<Image> {
  late final _$args = ref.$arg as double;
  double get pixelRatio => _$args;

  FutureOr<Image> build({required double pixelRatio});
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(pixelRatio: _$args);
    final ref = this.ref as $Ref<AsyncValue<Image>, Image>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Image>, Image>,
              AsyncValue<Image>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(BarPosition)
const barPositionProvider = BarPositionProvider._();

final class BarPositionProvider extends $NotifierProvider<BarPosition, int> {
  const BarPositionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'barPositionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$barPositionHash();

  @$internal
  @override
  BarPosition create() => BarPosition();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$barPositionHash() => r'9c0116be108db48b1a4e663916637e9e69391cd1';

abstract class _$BarPosition extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(NavigationBarColor)
const navigationBarColorProvider = NavigationBarColorProvider._();

final class NavigationBarColorProvider
    extends $NotifierProvider<NavigationBarColor, bool> {
  const NavigationBarColorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'navigationBarColorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$navigationBarColorHash();

  @$internal
  @override
  NavigationBarColor create() => NavigationBarColor();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$navigationBarColorHash() =>
    r'f69b58675ca3e60b9e713b0331f42c28a175c68a';

abstract class _$NavigationBarColor extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
