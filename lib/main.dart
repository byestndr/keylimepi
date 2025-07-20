import 'package:flutter/material.dart';
import 'package:spotimmich/player_page.dart';
import 'package:spotimmich/song_select.dart';
import 'package:spotimmich/widgets/playbackbar.dart';
import 'package:spotimmich/settings/spotify/spotifyauth.dart';
import 'dart:convert';
import 'package:spotimmich/settings/spotify/spotifyapi.dart';
import 'package:spotimmich/settings/settings.dart';
import 'dart:async';
import 'package:flutter/gestures.dart';

void main() {
  runApp(const App());
  preferences().removeIntValue('playback_state_counter');
  isLoggedIn();
  Timer.periodic(const Duration(minutes: 15), (Timer timer) {
    isLoggedIn();
  });
}

class ScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    // etc.
  };
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  Timer? timer;
  ColorScheme _colorScheme = ColorScheme.fromSeed(
    seedColor: Colors.lightGreen,
    brightness: Brightness.dark,
  );

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 10), (Timer timer) async {
      await RefreshLoop();
    });
  }

  Future<void> RefreshLoop() async {
    final String playstate = await Interactions().cachedPlaybackStateResponse(
      functionName: 'ColorScheme',
    );
    ColorScheme newcs = ColorScheme.fromSeed(
      seedColor: Colors.lightGreen,
      brightness: Brightness.dark,
    );

    try {
      final dynamic body = jsonDecode(playstate);
      final String imageURL = body['item']['album']['images'][0]['url'];
      newcs = await ColorScheme.fromImageProvider(
        brightness: Brightness.dark,
        provider: NetworkImage(imageURL),
      );
    } on FormatException {
      newcs = ColorScheme.fromSeed(
        seedColor: Colors.lightGreen,
        brightness: Brightness.dark,
      );
    } on NoSuchMethodError {
      newcs = ColorScheme.fromSeed(
        seedColor: Colors.lightGreen,
        brightness: Brightness.dark,
      );
    }

    setState(() {
      _colorScheme = newcs;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: ScrollBehavior(),
      home: const MusicPage(),
      theme: ThemeData(colorScheme: _colorScheme, fontFamily: 'Noto Sans'),
    );
  }
}

class MusicPage extends StatefulWidget {
  const MusicPage({super.key});

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  int currentPageIndex = 0;
  static const int navigationRailBreakpoint = 600;
  static const List<Widget> navigationPages = <Widget>[
    ImmichCarousel(),
    SongSelect(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      bottomNavigationBar: const BottomPlaybar(),
      appBar: MediaQuery.of(context).size.width <= navigationRailBreakpoint
          ? PreferredSize(
              preferredSize: const Size(double.infinity, kToolbarHeight),
              child: NavigationBar(
                onDestinationSelected: (int newPageIndex) {
                  setState(() {
                    currentPageIndex = newPageIndex;
                  });
                },
                backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
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
        ],
      ),
      extendBodyBehindAppBar:
          MediaQuery.of(context).size.width <= navigationRailBreakpoint
          ? false
          : true,
    );
  }
}
