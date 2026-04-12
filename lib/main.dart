import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotimmich/app_body.dart';
import 'package:flutter/gestures.dart';
import 'package:spotimmich/providers/theme/colorscheme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: AppEntrypoint()));
}

class ScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => <PointerDeviceKind>{
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    // etc.
  };
}

class AppEntrypoint extends ConsumerWidget {
  const AppEntrypoint({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ColorScheme> appColorScheme = ref.watch(
      appColorSchemeProvider,
    );

    return MaterialApp(
      scrollBehavior: ScrollBehavior(),
      home: const AppBody(),
      theme: ThemeData(
        colorScheme: appColorScheme.when(
          skipError: true,
          skipLoadingOnRefresh: true,
          skipLoadingOnReload: true,
          data: (ColorScheme appscheme) => appscheme,
          error: (Object error, StackTrace stacktrace) {
            ColorScheme.fromSeed(
              seedColor: Colors.lightGreen,
              brightness: Brightness.dark,
            );
          },
          loading: () => ColorScheme.fromSeed(
            seedColor: Colors.lightGreen,
            brightness: Brightness.dark,
          ),
        ),
        fontFamily: 'Noto Sans',
      ),
    );
  }
}
