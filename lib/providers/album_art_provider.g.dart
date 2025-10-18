// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_art_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AlbumImage)
const albumImageProvider = AlbumImageProvider._();

final class AlbumImageProvider
    extends $AsyncNotifierProvider<AlbumImage, String> {
  const AlbumImageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'albumImageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$albumImageHash();

  @$internal
  @override
  AlbumImage create() => AlbumImage();
}

String _$albumImageHash() => r'95409676020ab737e560cf749770313e51ced36b';

abstract class _$AlbumImage extends $AsyncNotifier<String> {
  FutureOr<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<String>, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String>, String>,
              AsyncValue<String>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
