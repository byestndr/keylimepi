// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seekbar_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SeekbarTimer)
final seekbarTimerProvider = SeekbarTimerProvider._();

final class SeekbarTimerProvider extends $NotifierProvider<SeekbarTimer, int> {
  SeekbarTimerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'seekbarTimerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$seekbarTimerHash();

  @$internal
  @override
  SeekbarTimer create() => SeekbarTimer();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$seekbarTimerHash() => r'a3de5f88a9535f6abe43fc7bf2656a342266ae46';

abstract class _$SeekbarTimer extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(GetNewSeekbarPosition)
final getNewSeekbarPositionProvider = GetNewSeekbarPositionProvider._();

final class GetNewSeekbarPositionProvider
    extends $AsyncNotifierProvider<GetNewSeekbarPosition, void> {
  GetNewSeekbarPositionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getNewSeekbarPositionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getNewSeekbarPositionHash();

  @$internal
  @override
  GetNewSeekbarPosition create() => GetNewSeekbarPosition();
}

String _$getNewSeekbarPositionHash() =>
    r'5b25f8796e8054d45186e58861062454e82d49df';

abstract class _$GetNewSeekbarPosition extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(SeekbarPosition)
final seekbarPositionProvider = SeekbarPositionProvider._();

final class SeekbarPositionProvider
    extends $NotifierProvider<SeekbarPosition, SeekbarTime> {
  SeekbarPositionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'seekbarPositionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$seekbarPositionHash();

  @$internal
  @override
  SeekbarPosition create() => SeekbarPosition();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SeekbarTime value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SeekbarTime>(value),
    );
  }
}

String _$seekbarPositionHash() => r'd3fa3cb5ece964d5e22b31c92117eff1dc90a81f';

abstract class _$SeekbarPosition extends $Notifier<SeekbarTime> {
  SeekbarTime build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SeekbarTime, SeekbarTime>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SeekbarTime, SeekbarTime>,
              SeekbarTime,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(seekbarPause)
final seekbarPauseProvider = SeekbarPauseProvider._();

final class SeekbarPauseProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  SeekbarPauseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'seekbarPauseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$seekbarPauseHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return seekbarPause(ref);
  }
}

String _$seekbarPauseHash() => r'5cf5cbaa836527505ea04a78aa59de6588d5a736';
