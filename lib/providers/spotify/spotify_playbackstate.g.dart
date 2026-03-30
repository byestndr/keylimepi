// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spotify_playbackstate.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SpotifyPlaybackstate)
final spotifyPlaybackstateProvider = SpotifyPlaybackstateProvider._();

final class SpotifyPlaybackstateProvider
    extends $AsyncNotifierProvider<SpotifyPlaybackstate, Map<String, dynamic>> {
  SpotifyPlaybackstateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'spotifyPlaybackstateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$spotifyPlaybackstateHash();

  @$internal
  @override
  SpotifyPlaybackstate create() => SpotifyPlaybackstate();
}

String _$spotifyPlaybackstateHash() =>
    r'0a3b14909aedb91846d6a53471be51e3211cd313';

abstract class _$SpotifyPlaybackstate
    extends $AsyncNotifier<Map<String, dynamic>> {
  FutureOr<Map<String, dynamic>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<Map<String, dynamic>>, Map<String, dynamic>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<Map<String, dynamic>>,
                Map<String, dynamic>
              >,
              AsyncValue<Map<String, dynamic>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
