import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotimmich/player_page.dart';
import 'package:spotimmich/providers/settings_provider.dart';
import 'package:spotimmich/settings/preferences.dart';
import 'package:spotimmich/settings/settings.dart';
import 'package:spotimmich/song_select.dart';
import 'package:spotimmich/widgets/control/playbackbar.dart';

class AppBody extends ConsumerStatefulWidget {
  const AppBody({super.key});

  @override
  ConsumerState<AppBody> createState() => _MusicPageState();
}

class _MusicPageState extends ConsumerState<AppBody> {
  int _currentPageIndex = 1;
  late PageController _pageController;
  static const List<Widget> _navigationPages = <Widget>[
    SettingsPage(),
    FullPlayerPage(),
    SongSelect(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserValues preferences = ref.watch(userSettingsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      bottomNavigationBar: const BottomPlaybar(),
      appBar: preferences.navigationBarOn
          ? PreferredSize(
              preferredSize: Size(
                double.infinity,
                preferences.navigationBarTransparent ? 100 : kToolbarHeight,
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
                backgroundColor: preferences.navigationBarTransparent
                    ? Colors.transparent
                    : Theme.of(context).colorScheme.surfaceContainer,
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

      body: PageView(
        physics: const BouncingScrollPhysics(),
        onPageChanged: (int value) => setState(() {
          _currentPageIndex = value;
        }),
        controller: _pageController,
        children: _navigationPages,
      ),
      extendBodyBehindAppBar: preferences.navigationBarTransparent,
    );
  }
}
