import 'package:flutter/material.dart';
import 'package:spotimmich/homepage.dart';
import 'package:spotimmich/playbackbar.dart';
import 'package:spotimmich/settings/spotify/spotifyauth.dart';
import 'dart:convert';
import 'settings/spotify/spotifyapi.dart';
import 'settings/settings.dart';
import 'dart:async';

void main() {
  runApp(App());
  preferences().removeIntValue('playback_state_counter');
  isLoggedIn();
  Timer.periodic(const Duration(minutes: 15), (Timer timer) {
    isLoggedIn();
  });
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

    timer = Timer.periodic(const Duration(seconds: 10), (Timer timer) {
      RefreshLoop();
    });
  }

  void RefreshLoop() async {
    final playstate = await Interactions().cachedPlaybackStateResponse(
      functionName: 'ColorScheme',
    );
    ColorScheme newcs = ColorScheme.fromSeed(
      seedColor: Colors.lightGreen,
      brightness: Brightness.dark,
    );

    try {
      final body = jsonDecode(playstate);
      var imageURL = body['item']['album']['images'][0]['url'];
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
      home: MusicPage(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      bottomNavigationBar: BottomPlaybar(),
      body: Row(
        children: [
          NavigationRail(
            onDestinationSelected: (int newPageIndex) {
              setState(() {
                currentPageIndex = newPageIndex;
              });
            },
            backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
            groupAlignment: 0,
            labelType: NavigationRailLabelType.all,
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.music_note),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings),
                label: Text('Settings'),
              ),
            ],
            selectedIndex: currentPageIndex,
          ),

          Expanded(
            child: IndexedStack(
              index: currentPageIndex,
              children: const [ImmichCarousel(), SettingsPage()],
            ),
          ),
        ],
      ),

      extendBodyBehindAppBar: true,
    );
  }
}
