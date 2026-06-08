// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_info_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GetPlaylistItems)
final getPlaylistItemsProvider = GetPlaylistItemsProvider._();

final class GetPlaylistItemsProvider
    extends $AsyncNotifierProvider<GetPlaylistItems, dynamic> {
  GetPlaylistItemsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getPlaylistItemsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getPlaylistItemsHash();

  @$internal
  @override
  GetPlaylistItems create() => GetPlaylistItems();
}

String _$getPlaylistItemsHash() => r'8d813916ef328df3233a5a792ecdf9a3e1f23be7';

abstract class _$GetPlaylistItems extends $AsyncNotifier<dynamic> {
  FutureOr<dynamic> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<dynamic>, dynamic>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<dynamic>, dynamic>,
              AsyncValue<dynamic>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
