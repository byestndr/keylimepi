// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'colorscheme.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(appColorScheme)
const appColorSchemeProvider = AppColorSchemeProvider._();

final class AppColorSchemeProvider
    extends $AsyncNotifierProvider<appColorScheme, ColorScheme> {
  const AppColorSchemeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appColorSchemeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appColorSchemeHash();

  @$internal
  @override
  appColorScheme create() => appColorScheme();
}

String _$appColorSchemeHash() => r'4f4fdb755684ad7b9582fdaf107bf973c218acc7';

abstract class _$appColorScheme extends $AsyncNotifier<ColorScheme> {
  FutureOr<ColorScheme> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<ColorScheme>, ColorScheme>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ColorScheme>, ColorScheme>,
              AsyncValue<ColorScheme>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
