// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SpotifyQueue)
final spotifyQueueProvider = SpotifyQueueProvider._();

final class SpotifyQueueProvider
    extends $AsyncNotifierProvider<SpotifyQueue, List<Song>> {
  SpotifyQueueProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'spotifyQueueProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$spotifyQueueHash();

  @$internal
  @override
  SpotifyQueue create() => SpotifyQueue();
}

String _$spotifyQueueHash() => r'b37fd123492ff5a089a3b9bd9c4266612662fb1a';

abstract class _$SpotifyQueue extends $AsyncNotifier<List<Song>> {
  FutureOr<List<Song>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Song>>, List<Song>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Song>>, List<Song>>,
              AsyncValue<List<Song>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
