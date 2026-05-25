// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lyrics_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LyricsGetter)
final lyricsGetterProvider = LyricsGetterProvider._();

final class LyricsGetterProvider
    extends $AsyncNotifierProvider<LyricsGetter, List<LyricLine>> {
  LyricsGetterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lyricsGetterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lyricsGetterHash();

  @$internal
  @override
  LyricsGetter create() => LyricsGetter();
}

String _$lyricsGetterHash() => r'488c05fbe2aba100127a5dc9070bab5043e88398';

abstract class _$LyricsGetter extends $AsyncNotifier<List<LyricLine>> {
  FutureOr<List<LyricLine>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<LyricLine>>, List<LyricLine>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<LyricLine>>, List<LyricLine>>,
              AsyncValue<List<LyricLine>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(lyricSync)
final lyricSyncProvider = LyricSyncProvider._();

final class LyricSyncProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<int>>,
          List<int>,
          FutureOr<List<int>>
        >
    with $FutureModifier<List<int>>, $FutureProvider<List<int>> {
  LyricSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lyricSyncProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lyricSyncHash();

  @$internal
  @override
  $FutureProviderElement<List<int>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<int>> create(Ref ref) {
    return lyricSync(ref);
  }
}

String _$lyricSyncHash() => r'53df989d0aed9a51fce7a4e701d089c1083d7298';

@ProviderFor(CurrentLyricIndex)
final currentLyricIndexProvider = CurrentLyricIndexProvider._();

final class CurrentLyricIndexProvider
    extends $AsyncNotifierProvider<CurrentLyricIndex, int> {
  CurrentLyricIndexProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentLyricIndexProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentLyricIndexHash();

  @$internal
  @override
  CurrentLyricIndex create() => CurrentLyricIndex();
}

String _$currentLyricIndexHash() => r'0dcb785c838444bed9692d943a9bc46f1114cf59';

abstract class _$CurrentLyricIndex extends $AsyncNotifier<int> {
  FutureOr<int> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<int>, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<int>, int>,
              AsyncValue<int>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(LyricDelay)
final lyricDelayProvider = LyricDelayProvider._();

final class LyricDelayProvider extends $NotifierProvider<LyricDelay, int> {
  LyricDelayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lyricDelayProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lyricDelayHash();

  @$internal
  @override
  LyricDelay create() => LyricDelay();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$lyricDelayHash() => r'e3464d204c6f5eb79289540b360a8f8bb57510db';

abstract class _$LyricDelay extends $Notifier<int> {
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
