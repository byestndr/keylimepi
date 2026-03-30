import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotimmich/backend/spotify/spotify_api-chopper.dart';
import 'package:spotimmich/player_page.dart';
import 'package:spotimmich/providers/theme/background_getter.dart';
import 'package:spotimmich/song_select.dart';
import 'package:spotimmich/widgets/control/playbackbar.dart';
import 'package:spotimmich/backend/spotify/spotifyauth.dart';
import 'package:spotimmich/settings/preferences.dart';
import 'package:spotimmich/settings/settings.dart';
import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:spotimmich/widgets/info/song_queue.dart';
import 'package:spotimmich/providers/theme/colorscheme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await isLoggedIn();
  await AsyncPreferences().removeIntValue('playback_state_counter');
  runApp(const ProviderScope(child: App()));

  Timer.periodic(const Duration(minutes: 15), (Timer timer) {
    isLoggedIn();
  });
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

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ColorScheme> appColorScheme = ref.watch(
      appColorSchemeProvider,
    );

    return MaterialApp(
      scrollBehavior: ScrollBehavior(),
      home: const MusicPage(),
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

class MusicPage extends ConsumerStatefulWidget {
  const MusicPage({super.key});

  @override
  ConsumerState<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends ConsumerState<MusicPage> {
  int currentPageIndex = 0;
  bool queueExpanded = false;
  static const int navigationRailBreakpoint = 600;
  static const List<Widget> navigationPages = <Widget>[
    FullPlayerPage(),
    SongSelect(),
    SettingsPage(),
  ];

  void queueExpandedButton(bool data) {
    if (!mounted) {
      return;
    }

    setState(() {
      queueExpanded = data;
    });
  }

  @override
  void initState() {
    super.initState();
    getNaviBarColor();
  }

  Future<void> getNaviBarColor() async {
    final bool? naviState = await AsyncPreferences().getBoolValue(
      'transparent_navibar',
    );

    if (naviState == null) {
      ref.read(navigationBarColorProvider.notifier).changeColor(false);
    } else {
      ref.read(navigationBarColorProvider.notifier).changeColor(naviState);
    }

    return;
  }

  @override
  Widget build(BuildContext context) {
    final bool navibarState = ref.watch(navigationBarColorProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      bottomNavigationBar: BottomPlaybar(isQueueExpanded: queueExpandedButton),
      appBar: MediaQuery.of(context).size.width <= navigationRailBreakpoint
          ? PreferredSize(
              preferredSize: Size(
                double.infinity,
                !navibarState ? kToolbarHeight : 100,
              ),
              child: NavigationBar(
                onDestinationSelected: (int newPageIndex) {
                  setState(() {
                    currentPageIndex = newPageIndex;
                  });
                },
                backgroundColor: !navibarState
                    ? Theme.of(context).colorScheme.surfaceContainer
                    : Colors.transparent,
                destinations: <NavigationDestination>[
                  const NavigationDestination(
                    icon: Icon(Icons.music_note),
                    label: 'Player',
                  ),
                  const NavigationDestination(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  const NavigationDestination(
                    icon: Icon(Icons.settings),
                    label: 'Settings',
                  ),
                ],
                selectedIndex: currentPageIndex,
              ),
            )
          : const PreferredSize(
              preferredSize: Size(double.infinity, kToolbarHeight),
              child: SizedBox.shrink(),
            ),
      body: Row(
        children: <Widget>[
          MediaQuery.of(context).size.width >= navigationRailBreakpoint
              ? NavigationRail(
                  onDestinationSelected: (int newPageIndex) {
                    setState(() {
                      currentPageIndex = newPageIndex;
                    });
                  },
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainer,
                  groupAlignment: 0,
                  labelType: NavigationRailLabelType.all,
                  destinations: <NavigationRailDestination>[
                    const NavigationRailDestination(
                      icon: Icon(Icons.music_note),
                      label: Text('Player'),
                    ),
                    const NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    const NavigationRailDestination(
                      icon: Icon(Icons.settings),
                      label: Text('Settings'),
                    ),
                  ],
                  selectedIndex: currentPageIndex,
                )
              : const SizedBox.shrink(),

          Expanded(child: navigationPages[currentPageIndex]),
          if (currentPageIndex != 2)
            const QueueSideSheet()
          else
            const Padding(padding: EdgeInsetsGeometry.zero),
        ],
      ),
      extendBodyBehindAppBar: navibarState,
    );
  }
}
