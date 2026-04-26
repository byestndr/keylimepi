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
