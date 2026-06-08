// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_info_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GetSongItems)
final getSongItemsProvider = GetSongItemsFamily._();

final class GetSongItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Response<dynamic>>,
          Response<dynamic>,
          FutureOr<Response<dynamic>>
        >
    with
        $FutureModifier<Response<dynamic>>,
        $FutureProvider<Response<dynamic>> {
  GetSongItemsProvider._({
    required GetSongItemsFamily super.from,
    required ({bool isPlaylist, String id, int offset}) super.argument,
  }) : super(
         retry: null,
         name: r'getSongItemsProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getSongItemsHash();

  @override
  String toString() {
    return r'getSongItemsProvider'
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
    final argument =
        this.argument as ({bool isPlaylist, String id, int offset});
    return GetSongItems(
      ref,
      isPlaylist: argument.isPlaylist,
      id: argument.id,
      offset: argument.offset,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetSongItemsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getSongItemsHash() => r'ddc4363cb5d25163248c24b9236c2d006b140d6c';

final class GetSongItemsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Response<dynamic>>,
          ({bool isPlaylist, String id, int offset})
        > {
  GetSongItemsFamily._()
    : super(
        retry: null,
        name: r'getSongItemsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  GetSongItemsProvider call({
    required bool isPlaylist,
    required String id,
    int offset = 0,
  }) => GetSongItemsProvider._(
    argument: (isPlaylist: isPlaylist, id: id, offset: offset),
    from: this,
  );

  @override
  String toString() => r'getSongItemsProvider';
}
