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

String _$lyricsGetterHash() => r'6b12e2091af7f1ec0aa7e5ca9c9c59d586387273';

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

@ProviderFor(LyricSearch)
final lyricSearchProvider = LyricSearchProvider._();

final class LyricSearchProvider
    extends $AsyncNotifierProvider<LyricSearch, List<dynamic>> {
  LyricSearchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lyricSearchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lyricSearchHash();

  @$internal
  @override
  LyricSearch create() => LyricSearch();
}

String _$lyricSearchHash() => r'50b7d620dd229c311088c0c11fb0c9e8dd0b9c9f';

abstract class _$LyricSearch extends $AsyncNotifier<List<dynamic>> {
  FutureOr<List<dynamic>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<dynamic>>, List<dynamic>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<dynamic>>, List<dynamic>>,
              AsyncValue<List<dynamic>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(LyricSearchFilter)
final lyricSearchFilterProvider = LyricSearchFilterProvider._();

final class LyricSearchFilterProvider
    extends $NotifierProvider<LyricSearchFilter, SearchFilter> {
  LyricSearchFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lyricSearchFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lyricSearchFilterHash();

  @$internal
  @override
  LyricSearchFilter create() => LyricSearchFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SearchFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchFilter>(value),
    );
  }
}

String _$lyricSearchFilterHash() => r'5b8224c27a6a3526cf3bd55760eb346ed5b3bec9';

abstract class _$LyricSearchFilter extends $Notifier<SearchFilter> {
  SearchFilter build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SearchFilter, SearchFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SearchFilter, SearchFilter>,
              SearchFilter,
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
