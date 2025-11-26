// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'likedSongs_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SongProvider)
const songProviderProvider = SongProviderProvider._();

final class SongProviderProvider
    extends $AsyncNotifierProvider<SongProvider, List<dynamic>> {
  const SongProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'songProviderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$songProviderHash();

  @$internal
  @override
  SongProvider create() => SongProvider();
}

String _$songProviderHash() => r'3cebecfca19e115a8528e298212041ced89eafdc';

abstract class _$SongProvider extends $AsyncNotifier<List<dynamic>> {
  FutureOr<List<dynamic>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<dynamic>>, List<dynamic>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<dynamic>>, List<dynamic>>,
              AsyncValue<List<dynamic>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
