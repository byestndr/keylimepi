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
    extends $AsyncNotifierProvider<SpotifyQueue, List<SpotifyQueueItem>> {
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

String _$spotifyQueueHash() => r'785c6fbadb092e190908fb84d72f16bb19e437a0';

abstract class _$SpotifyQueue extends $AsyncNotifier<List<SpotifyQueueItem>> {
  FutureOr<List<SpotifyQueueItem>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<SpotifyQueueItem>>, List<SpotifyQueueItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<SpotifyQueueItem>>,
                List<SpotifyQueueItem>
              >,
              AsyncValue<List<SpotifyQueueItem>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
