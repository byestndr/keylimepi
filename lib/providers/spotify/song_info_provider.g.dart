// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_info_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(refreshTimer)
final refreshTimerProvider = RefreshTimerProvider._();

final class RefreshTimerProvider
    extends $FunctionalProvider<AsyncValue<void>, void, Stream<void>>
    with $FutureModifier<void>, $StreamProvider<void> {
  RefreshTimerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'refreshTimerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$refreshTimerHash();

  @$internal
  @override
  $StreamProviderElement<void> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<void> create(Ref ref) {
    return refreshTimer(ref);
  }
}

String _$refreshTimerHash() => r'7719fa0adc9be94cc07f2950d8283b2b701d2338';

@ProviderFor(InfoGetter)
final infoGetterProvider = InfoGetterProvider._();

final class InfoGetterProvider
    extends $AsyncNotifierProvider<InfoGetter, SpotifySong?> {
  InfoGetterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'infoGetterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$infoGetterHash();

  @$internal
  @override
  InfoGetter create() => InfoGetter();
}

String _$infoGetterHash() => r'0fc5e6df68cb6af3f47fdbbc1eb538c739ef41b7';

abstract class _$InfoGetter extends $AsyncNotifier<SpotifySong?> {
  FutureOr<SpotifySong?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<SpotifySong?>, SpotifySong?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SpotifySong?>, SpotifySong?>,
              AsyncValue<SpotifySong?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(isQueueExpanded)
final isQueueExpandedProvider = IsQueueExpandedProvider._();

final class IsQueueExpandedProvider
    extends $NotifierProvider<isQueueExpanded, bool> {
  IsQueueExpandedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isQueueExpandedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isQueueExpandedHash();

  @$internal
  @override
  isQueueExpanded create() => isQueueExpanded();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isQueueExpandedHash() => r'6a9766efcb93f83cb56c4c594347a4dd32829d73';

abstract class _$isQueueExpanded extends $Notifier<bool> {
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

@ProviderFor(SongLatency)
final songLatencyProvider = SongLatencyProvider._();

final class SongLatencyProvider
    extends $NotifierProvider<SongLatency, Stopwatch> {
  SongLatencyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'songLatencyProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$songLatencyHash();

  @$internal
  @override
  SongLatency create() => SongLatency();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Stopwatch value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Stopwatch>(value),
    );
  }
}

String _$songLatencyHash() => r'814c9c979ba848b393e25228fc05070f7bf2203d';

abstract class _$SongLatency extends $Notifier<Stopwatch> {
  Stopwatch build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Stopwatch, Stopwatch>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Stopwatch, Stopwatch>,
              Stopwatch,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
