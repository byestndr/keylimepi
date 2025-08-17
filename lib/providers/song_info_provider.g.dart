// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_info_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(refreshTimer)
const refreshTimerProvider = RefreshTimerProvider._();

final class RefreshTimerProvider
    extends $FunctionalProvider<AsyncValue<void>, void, Stream<void>>
    with $FutureModifier<void>, $StreamProvider<void> {
  const RefreshTimerProvider._()
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

String _$refreshTimerHash() => r'68a378b7e84726f0022bbe6a0fee81b041cacee7';

@ProviderFor(OldSong)
const oldSongProvider = OldSongProvider._();

final class OldSongProvider extends $NotifierProvider<OldSong, Song> {
  const OldSongProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'oldSongProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$oldSongHash();

  @$internal
  @override
  OldSong create() => OldSong();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Song value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Song>(value),
    );
  }
}

String _$oldSongHash() => r'f86a6c74580a994168098f606b06163dd5b9b75b';

abstract class _$OldSong extends $Notifier<Song> {
  Song build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Song, Song>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Song, Song>,
              Song,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(InfoGetter)
const infoGetterProvider = InfoGetterProvider._();

final class InfoGetterProvider
    extends $AsyncNotifierProvider<InfoGetter, Song> {
  const InfoGetterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'infoGetterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$infoGetterHash();

  @$internal
  @override
  InfoGetter create() => InfoGetter();
}

String _$infoGetterHash() => r'354c2b4b33b06d40264bbcd6d1479a88cb68afd9';

abstract class _$InfoGetter extends $AsyncNotifier<Song> {
  FutureOr<Song> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<Song>, Song>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Song>, Song>,
              AsyncValue<Song>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
