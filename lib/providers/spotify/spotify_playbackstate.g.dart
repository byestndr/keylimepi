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
    extends $AsyncNotifierProvider<SpotifyPlaybackstate, Response<dynamic>> {
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
    r'57793abbbb4240dd3ec31e339b9ffb6fd0385297';

abstract class _$SpotifyPlaybackstate
    extends $AsyncNotifier<Response<dynamic>> {
  FutureOr<Response<dynamic>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<Response<dynamic>>, Response<dynamic>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Response<dynamic>>, Response<dynamic>>,
              AsyncValue<Response<dynamic>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
