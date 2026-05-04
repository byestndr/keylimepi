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

String _$lyricsGetterHash() => r'5aaa25e8267fb0f5ddb298988adcb266058868c3';

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

@ProviderFor(LyricSync)
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
    return LyricSync(ref);
  }
}

String _$lyricSyncHash() => r'22b959ca8d0ad6e823f896cd63b48d90d86e5d1b';

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

String _$currentLyricIndexHash() => r'8f3e7aa8f4eef0df47e97a13ab280af5057ed803';

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
