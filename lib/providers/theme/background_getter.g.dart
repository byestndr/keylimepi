// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'background_getter.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BackgroundOpacity)
final backgroundOpacityProvider = BackgroundOpacityProvider._();

final class BackgroundOpacityProvider
    extends $NotifierProvider<BackgroundOpacity, int> {
  BackgroundOpacityProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'backgroundOpacityProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$backgroundOpacityHash();

  @$internal
  @override
  BackgroundOpacity create() => BackgroundOpacity();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$backgroundOpacityHash() => r'efced6eb7db14586ab8701c7183fde0301ce4e36';

abstract class _$BackgroundOpacity extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
