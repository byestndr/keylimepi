// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LyricCache)
final lyricCacheProvider = LyricCacheProvider._();

final class LyricCacheProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LyricLine>?>,
          List<LyricLine>?,
          FutureOr<List<LyricLine>?>
        >
    with $FutureModifier<List<LyricLine>?>, $FutureProvider<List<LyricLine>?> {
  LyricCacheProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lyricCacheProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lyricCacheHash();

  @$internal
  @override
  $FutureProviderElement<List<LyricLine>?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<LyricLine>?> create(Ref ref) {
    return LyricCache(ref);
  }
}

String _$lyricCacheHash() => r'bd71eca385c800aec8fe871e9dffc5a63eb89e20';
