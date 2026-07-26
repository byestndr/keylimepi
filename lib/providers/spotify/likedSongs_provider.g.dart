// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'likedSongs_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SongProvider)
final songProviderProvider = SongProviderProvider._();

final class SongProviderProvider
    extends $AsyncNotifierProvider<SongProvider, List<dynamic>> {
  SongProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'songProviderProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$songProviderHash();

  @$internal
  @override
  SongProvider create() => SongProvider();
}

String _$songProviderHash() => r'fccba95b21d863365b5fa2130ef4c822398a3b20';

abstract class _$SongProvider extends $AsyncNotifier<List<dynamic>> {
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
