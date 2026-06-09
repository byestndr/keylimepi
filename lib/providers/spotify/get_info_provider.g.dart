// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_info_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getItemSongs)
final getItemSongsProvider = GetItemSongsFamily._();

final class GetItemSongsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<dynamic>>,
          List<dynamic>,
          FutureOr<List<dynamic>>
        >
    with $FutureModifier<List<dynamic>>, $FutureProvider<List<dynamic>> {
  GetItemSongsProvider._({
    required GetItemSongsFamily super.from,
    required ({String id, bool isPlaylist}) super.argument,
  }) : super(
         retry: null,
         name: r'getItemSongsProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getItemSongsHash();

  @override
  String toString() {
    return r'getItemSongsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<dynamic>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<dynamic>> create(Ref ref) {
    final argument = this.argument as ({String id, bool isPlaylist});
    return getItemSongs(ref, id: argument.id, isPlaylist: argument.isPlaylist);
  }

  @override
  bool operator ==(Object other) {
    return other is GetItemSongsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getItemSongsHash() => r'ed7696940331752e979798daa6e4672d76d0bb59';

final class GetItemSongsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<dynamic>>,
          ({String id, bool isPlaylist})
        > {
  GetItemSongsFamily._()
    : super(
        retry: null,
        name: r'getItemSongsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  GetItemSongsProvider call({required String id, required bool isPlaylist}) =>
      GetItemSongsProvider._(
        argument: (id: id, isPlaylist: isPlaylist),
        from: this,
      );

  @override
  String toString() => r'getItemSongsProvider';
}
