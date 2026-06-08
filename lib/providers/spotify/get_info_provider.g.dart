// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_info_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GetPlaylistItems)
final getPlaylistItemsProvider = GetPlaylistItemsFamily._();

final class GetPlaylistItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Response<dynamic>>,
          Response<dynamic>,
          FutureOr<Response<dynamic>>
        >
    with
        $FutureModifier<Response<dynamic>>,
        $FutureProvider<Response<dynamic>> {
  GetPlaylistItemsProvider._({
    required GetPlaylistItemsFamily super.from,
    required ({bool isPlaylist, String id}) super.argument,
  }) : super(
         retry: null,
         name: r'getPlaylistItemsProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getPlaylistItemsHash();

  @override
  String toString() {
    return r'getPlaylistItemsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Response<dynamic>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Response<dynamic>> create(Ref ref) {
    final argument = this.argument as ({bool isPlaylist, String id});
    return GetPlaylistItems(
      ref,
      isPlaylist: argument.isPlaylist,
      id: argument.id,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetPlaylistItemsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getPlaylistItemsHash() => r'0727e64e60fa0a948e76da8778f0021569c08a01';

final class GetPlaylistItemsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Response<dynamic>>,
          ({bool isPlaylist, String id})
        > {
  GetPlaylistItemsFamily._()
    : super(
        retry: null,
        name: r'getPlaylistItemsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  GetPlaylistItemsProvider call({
    required bool isPlaylist,
    required String id,
  }) => GetPlaylistItemsProvider._(
    argument: (isPlaylist: isPlaylist, id: id),
    from: this,
  );

  @override
  String toString() => r'getPlaylistItemsProvider';
}
