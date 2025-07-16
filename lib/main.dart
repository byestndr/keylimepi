import 'package:flutter/material.dart';
import 'package:spotimmich/playbackbar.dart';
import 'package:spotimmich/settings/immich/immichtokendialog.dart';
import 'package:spotimmich/settings/spotify/spotifyauth.dart';
import 'package:spotimmich/weatherwidget.dart';
import 'dart:convert';
import 'settings/spotify/spotifyapi.dart';
import 'songinfo.dart';
import 'settings/settings.dart';
import 'songimage.dart';
import 'controls.dart';
import 'dart:async';

void main() {
  runApp(App());
  preferences().removeIntValue('playback_state_counter');
  isLoggedIn();
  Timer timer = Timer.periodic(const Duration(minutes: 15), (Timer timer) {
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
  Timer? timer;
  dynamic backgroundImage = AssetImage('assets/imagePlaceholder.png');

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 10), (Timer timer) {
      RefreshLoop();
    });
  }

  void RefreshLoop() {
    setState(() {
      getBackgroundImage().then((value) {
        backgroundImage = value;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      bottomNavigationBar: BottomPlaybar(),
      body: Row(
        children: [
          NavigationRail(
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
            selectedIndex: 0,
          ),

          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: SizedBox.expand(
                    child: CarouselView.weighted(
                      scrollDirection: Axis.horizontal,
                      flexWeights: [10, 1, 1],
                      children: [
                        FittedBox(
                          fit: BoxFit.cover,
                          child: Image(image: backgroundImage),
                        ),
                        FittedBox(
                          fit: BoxFit.cover,
                          child: Image(image: backgroundImage),
                        ),
                        FittedBox(
                          fit: BoxFit.cover,
                          child: Image(image: backgroundImage),
                        ),
                      ],
                    ),
                  ),
                ),
                MediaWidget(),
              ],
            ),
          ),
        ],
      ),

      extendBodyBehindAppBar: true,
    );
  }
}

class MediaWidget extends StatelessWidget {
  const MediaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SongImage(),
        Padding(
          padding: EdgeInsetsGeometry.directional(bottom: 16),
          child: SongInfo(),
        ),
      ],
    );
  }
}
