// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_info_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(InfoGetter)
const infoGetterProvider = InfoGetterProvider._();

final class InfoGetterProvider
    extends $AsyncNotifierProvider<InfoGetter, Song> {
  const InfoGetterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'infoGetterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$infoGetterHash();

  @$internal
  @override
  InfoGetter create() => InfoGetter();
}

String _$infoGetterHash() => r'e12d41fbdd467fbf79e5b84a9cf127ad931104ad';

abstract class _$InfoGetter extends $AsyncNotifier<Song> {
  FutureOr<Song> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<Song>, Song>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Song>, Song>,
              AsyncValue<Song>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
