// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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

String _$lyricSearchHash() => r'9c9e79da889e99d25a120877fb1421f84f1689fa';

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

String _$lyricSearchFilterHash() => r'7fcd38f828acf9630d8fad329015f6746adba805';

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
