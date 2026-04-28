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
    extends $AsyncNotifierProvider<InfoGetter, Song> {
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

String _$infoGetterHash() => r'15bd26d68c2765578bc7b824df5bc7be984f1e0b';

abstract class _$InfoGetter extends $AsyncNotifier<Song> {
  FutureOr<Song> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Song>, Song>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Song>, Song>,
              AsyncValue<Song>,
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
