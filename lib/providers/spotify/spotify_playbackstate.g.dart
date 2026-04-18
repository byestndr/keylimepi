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

@ProviderFor(SpotifyAuthenticated)
final spotifyAuthenticatedProvider = SpotifyAuthenticatedProvider._();

final class SpotifyAuthenticatedProvider
    extends $NotifierProvider<SpotifyAuthenticated, bool> {
  SpotifyAuthenticatedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'spotifyAuthenticatedProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$spotifyAuthenticatedHash();

  @$internal
  @override
  SpotifyAuthenticated create() => SpotifyAuthenticated();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$spotifyAuthenticatedHash() =>
    r'0b062cc9a15e5778d3c48d5244344dd843ac7571';

abstract class _$SpotifyAuthenticated extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
