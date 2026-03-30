// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlists_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PlaylistsProvider)
final playlistsProviderProvider = PlaylistsProviderProvider._();

final class PlaylistsProviderProvider
    extends $AsyncNotifierProvider<PlaylistsProvider, List<dynamic>> {
  PlaylistsProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playlistsProviderProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playlistsProviderHash();

  @$internal
  @override
  PlaylistsProvider create() => PlaylistsProvider();
}

String _$playlistsProviderHash() => r'664ae5d9a3c6f6effb54ae1a81390e9d606026c1';

abstract class _$PlaylistsProvider extends $AsyncNotifier<List<dynamic>> {
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
