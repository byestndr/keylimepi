// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spotify_playbackstate.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SpotifyPlaybackState)
final spotifyPlaybackStateProvider = SpotifyPlaybackStateProvider._();

final class SpotifyPlaybackStateProvider
    extends $AsyncNotifierProvider<SpotifyPlaybackState, Response<dynamic>> {
  SpotifyPlaybackStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'spotifyPlaybackStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$spotifyPlaybackStateHash();

  @$internal
  @override
  SpotifyPlaybackState create() => SpotifyPlaybackState();
}

String _$spotifyPlaybackStateHash() =>
    r'76b38d43456a02e3d061e0a53ee10452d61f278b';

abstract class _$SpotifyPlaybackState
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
