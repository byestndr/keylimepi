// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seekbar_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SeekbarPosition)
final seekbarPositionProvider = SeekbarPositionProvider._();

final class SeekbarPositionProvider
    extends $NotifierProvider<SeekbarPosition, double> {
  SeekbarPositionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'seekbarPositionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$seekbarPositionHash();

  @$internal
  @override
  SeekbarPosition create() => SeekbarPosition();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double>(value),
    );
  }
}

String _$seekbarPositionHash() => r'ad3bbdcfb32a2b79f70ad4020fdf4533e1956080';

abstract class _$SeekbarPosition extends $Notifier<double> {
  double build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<double, double>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<double, double>,
              double,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
