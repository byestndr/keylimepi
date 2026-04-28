// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lyrics_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LyricsGetter)
final lyricsGetterProvider = LyricsGetterProvider._();

final class LyricsGetterProvider
    extends $AsyncNotifierProvider<LyricsGetter, Map<String, dynamic>> {
  LyricsGetterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lyricsGetterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lyricsGetterHash();

  @$internal
  @override
  LyricsGetter create() => LyricsGetter();
}

String _$lyricsGetterHash() => r'a0511cb0e750dcc9d757fbe6a3a7f97d6f8945b2';

abstract class _$LyricsGetter extends $AsyncNotifier<Map<String, dynamic>> {
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
