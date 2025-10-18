// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AlbumProvider)
const albumProviderProvider = AlbumProviderProvider._();

final class AlbumProviderProvider
    extends $AsyncNotifierProvider<AlbumProvider, List<dynamic>> {
  const AlbumProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'albumProviderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$albumProviderHash();

  @$internal
  @override
  AlbumProvider create() => AlbumProvider();
}

String _$albumProviderHash() => r'027b958c15ea13c2095d7ed0f4eb2fa74df0d77f';

abstract class _$AlbumProvider extends $AsyncNotifier<List<dynamic>> {
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
