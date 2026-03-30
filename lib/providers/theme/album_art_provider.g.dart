// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_art_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AlbumImage)
final albumImageProvider = AlbumImageProvider._();

final class AlbumImageProvider
    extends $AsyncNotifierProvider<AlbumImage, String> {
  AlbumImageProvider._()
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

String _$albumImageHash() => r'aecc5c0bf302a30abfaef4103875e541fae1f938';

abstract class _$AlbumImage extends $AsyncNotifier<String> {
  FutureOr<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<String>, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String>, String>,
              AsyncValue<String>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
