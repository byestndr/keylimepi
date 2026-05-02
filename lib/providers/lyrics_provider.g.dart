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

String _$lyricsGetterHash() => r'72a5116e8345648dd6ed00def44d5be28a0497fc';

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

@ProviderFor(CurrentLyric)
final currentLyricProvider = CurrentLyricProvider._();

final class CurrentLyricProvider
    extends $AsyncNotifierProvider<CurrentLyric, LyricLine> {
  CurrentLyricProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentLyricProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentLyricHash();

  @$internal
  @override
  CurrentLyric create() => CurrentLyric();
}

String _$currentLyricHash() => r'27cf87c2875b458f55a96e081d31ac3a6bb8c486';

abstract class _$CurrentLyric extends $AsyncNotifier<LyricLine> {
  FutureOr<LyricLine> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<LyricLine>, LyricLine>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<LyricLine>, LyricLine>,
              AsyncValue<LyricLine>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
