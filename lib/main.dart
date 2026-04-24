import 'package:chopper/src/response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotimmich/app_body.dart';
import 'package:flutter/gestures.dart';
import 'package:spotimmich/authentication_setup_page.dart';
import 'package:spotimmich/backend/spotify/spotify_api.dart';
import 'package:spotimmich/backend/spotify/spotify_authentication.dart';
import 'package:spotimmich/providers/settings_provider.dart';
import 'package:spotimmich/providers/theme/colorscheme.dart';
import 'package:spotimmich/settings/preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final UserValues userPreferences = await UserValues().getUpdatedValues();
  final SpotifyUserService service = SpotifyUserService.create();

  late bool authenticated;
  try {
    final Response<dynamic> response = await service.getPlayerState();
    authenticated = true;
  } on NotAuthenticatedException {
    authenticated = false;
  }

  runApp(
    ProviderScope(
      overrides: [
        userSettingsProvider.overrideWith(
          () => UserSettingsOverride(userPreferences),
        ),
      ],
      child: AppEntrypoint(isAuthenticated: authenticated),
    ),
  );
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
  final bool isAuthenticated;
  const AppEntrypoint({super.key, required this.isAuthenticated});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ColorScheme> appColorScheme = ref.watch(
      appColorSchemeProvider,
    );

    return MaterialApp(
      scrollBehavior: ScrollBehavior(),
      home: isAuthenticated ? const AppBody() : const AuthenticationSetupPage(),
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
