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
final lyricSearchProvider = LyricSearchFamily._();

final class LyricSearchProvider
    extends $AsyncNotifierProvider<LyricSearch, List<dynamic>> {
  LyricSearchProvider._({
    required LyricSearchFamily super.from,
    required (String, String, String) super.argument,
  }) : super(
         retry: null,
         name: r'lyricSearchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$lyricSearchHash();

  @override
  String toString() {
    return r'lyricSearchProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  LyricSearch create() => LyricSearch();

  @override
  bool operator ==(Object other) {
    return other is LyricSearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$lyricSearchHash() => r'e7baebba17f5c8b0e41d2cfa7b7900e3bf169bf3';

final class LyricSearchFamily extends $Family
    with
        $ClassFamilyOverride<
          LyricSearch,
          AsyncValue<List<dynamic>>,
          List<dynamic>,
          FutureOr<List<dynamic>>,
          (String, String, String)
        > {
  LyricSearchFamily._()
    : super(
        retry: null,
        name: r'lyricSearchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LyricSearchProvider call(String song, String album, String artist) =>
      LyricSearchProvider._(argument: (song, album, artist), from: this);

  @override
  String toString() => r'lyricSearchProvider';
}

abstract class _$LyricSearch extends $AsyncNotifier<List<dynamic>> {
  late final _$args = ref.$arg as (String, String, String);
  String get song => _$args.$1;
  String get album => _$args.$2;
  String get artist => _$args.$3;

  FutureOr<List<dynamic>> build(String song, String album, String artist);
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
    element.handleCreate(ref, () => build(_$args.$1, _$args.$2, _$args.$3));
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
