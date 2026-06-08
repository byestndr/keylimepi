// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'colorscheme.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appColorScheme)
final appColorSchemeProvider = AppColorSchemeProvider._();

final class AppColorSchemeProvider
    extends $AsyncNotifierProvider<appColorScheme, ColorScheme> {
  AppColorSchemeProvider._()
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

String _$appColorSchemeHash() => r'eb6d14ad51d7b188aaea602a9c8e2b7300c90116';

abstract class _$appColorScheme extends $AsyncNotifier<ColorScheme> {
  FutureOr<ColorScheme> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ColorScheme>, ColorScheme>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ColorScheme>, ColorScheme>,
              AsyncValue<ColorScheme>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(generateColorScheme)
final generateColorSchemeProvider = GenerateColorSchemeFamily._();

final class GenerateColorSchemeProvider
    extends
        $FunctionalProvider<
          AsyncValue<ColorScheme>,
          ColorScheme,
          FutureOr<ColorScheme>
        >
    with $FutureModifier<ColorScheme>, $FutureProvider<ColorScheme> {
  GenerateColorSchemeProvider._({
    required GenerateColorSchemeFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'generateColorSchemeProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$generateColorSchemeHash();

  @override
  String toString() {
    return r'generateColorSchemeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ColorScheme> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ColorScheme> create(Ref ref) {
    final argument = this.argument as String;
    return generateColorScheme(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GenerateColorSchemeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$generateColorSchemeHash() =>
    r'd2ca08aa0a4583df8dc2a6623b09efe29fb3d5e3';

final class GenerateColorSchemeFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ColorScheme>, String> {
  GenerateColorSchemeFamily._()
    : super(
        retry: null,
        name: r'generateColorSchemeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  GenerateColorSchemeProvider call(String image) =>
      GenerateColorSchemeProvider._(argument: image, from: this);

  @override
  String toString() => r'generateColorSchemeProvider';
}
