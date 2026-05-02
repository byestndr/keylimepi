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

String _$seekbarTimerHash() => r'0a8cfa86f49f10ad7f308b75d9b24ba386e740d4';

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

String _$seekbarPositionHash() => r'c98fdda571bac6842f938e7f50fd79cc43b20b49';

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

@ProviderFor(SeekbarPause)
final seekbarPauseProvider = SeekbarPauseProvider._();

final class SeekbarPauseProvider extends $NotifierProvider<SeekbarPause, bool> {
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
  SeekbarPause create() => SeekbarPause();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$seekbarPauseHash() => r'afb01dd1d0f5c99a100152701c61ff372d338c63';

abstract class _$SeekbarPause extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
