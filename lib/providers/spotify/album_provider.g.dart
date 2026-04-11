// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AlbumProvider)
final albumProviderProvider = AlbumProviderProvider._();

final class AlbumProviderProvider
    extends $AsyncNotifierProvider<AlbumProvider, List<dynamic>> {
  AlbumProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'albumProviderProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$albumProviderHash();

  @$internal
  @override
  AlbumProvider create() => AlbumProvider();
}

String _$albumProviderHash() => r'8cb36d84c86f01d1c925430f7b1cf4738827b3fc';

abstract class _$AlbumProvider extends $AsyncNotifier<List<dynamic>> {
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
