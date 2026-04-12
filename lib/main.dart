import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotimmich/player_page.dart';
import 'package:spotimmich/providers/theme/background_getter.dart';
import 'package:spotimmich/song_select.dart';
import 'package:spotimmich/widgets/control/playbackbar.dart';
import 'package:spotimmich/settings/preferences.dart';
import 'package:spotimmich/settings/settings.dart';
import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:spotimmich/widgets/info/song_queue.dart';
import 'package:spotimmich/providers/theme/colorscheme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: App()));
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
  int _currentPageIndex = 1;
  bool _queueExpanded = false;
  bool navbarOn = true;
  late PageController _pageController;
  static const List<Widget> _navigationPages = <Widget>[
    SettingsPage(),
    FullPlayerPage(),
    SongSelect(),
  ];

  void queueExpandedButton(bool data) {
    if (!mounted) {
      return;
    }

    setState(() {
      _queueExpanded = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1);
    getNaviBarColor();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
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

  Future<void> isNavbarEnabled() async {
    final bool? naviState = await AsyncPreferences().getBoolValue('navibar_on');
    setState(() {
      navbarOn = naviState ?? true;
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    final bool navibarState = ref.watch(navigationBarColorProvider);
    isNavbarEnabled();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      bottomNavigationBar: BottomPlaybar(isQueueExpanded: queueExpandedButton),
      appBar: navbarOn
          ? PreferredSize(
              preferredSize: Size(
                double.infinity,
                !navibarState ? kToolbarHeight : 100,
              ),
              child: NavigationBar(
                onDestinationSelected: (int newPageIndex) {
                  setState(() {
                    _currentPageIndex = newPageIndex;
                  });
                  _pageController.animateToPage(
                    _currentPageIndex,
                    duration: const Duration(milliseconds: 500),
                    curve: Easing.emphasizedDecelerate,
                  );
                },
                backgroundColor: !navibarState
                    ? Theme.of(context).colorScheme.surfaceContainer
                    : Colors.transparent,
                destinations: <NavigationDestination>[
                  const NavigationDestination(
                    icon: Icon(Icons.settings),
                    label: 'Settings',
                  ),
                  const NavigationDestination(
                    icon: Icon(Icons.music_note),
                    label: 'Player',
                  ),
                  const NavigationDestination(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                ],
                selectedIndex: _currentPageIndex,
              ),
            )
          : PreferredSize(preferredSize: .zero, child: Container()),

      body: Row(
        children: [
          Expanded(
            child: PageView(
              physics: const BouncingScrollPhysics(),
              onPageChanged: (int value) => setState(() {
                _currentPageIndex = value;
              }),
              controller: _pageController,
              children: _navigationPages,
            ),
          ),
          const QueueSideSheet(),
        ],
      ),
      extendBodyBehindAppBar: navibarState,
    );
  }
}
