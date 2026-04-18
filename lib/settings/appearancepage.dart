import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotimmich/providers/settings_provider.dart';
import 'package:spotimmich/settings/preferences.dart';

class AppearancePage extends StatelessWidget {
  const AppearancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SettingsList(),
      appBar: AppBar(title: const Text('Appearance')),
    );
  }
}

class SettingsList extends ConsumerStatefulWidget {
  const SettingsList({super.key});

  @override
  ConsumerState<SettingsList> createState() => _SettingsListState();
}

class _SettingsListState extends ConsumerState<SettingsList> {
  bool backgroundState = false;
  int? _currentAlignment = 1;
  double sliderValue = 0;
  bool isNavbarTransparent = false;
  bool navbarShown = false;

  @override
  void initState() {
    super.initState();
    getBackgroundToggle();
    getBarTransparency();
    isBarOn();
    getInfoAlignment();
    getBackgroundBlur();
  }

  void getBackgroundToggle() {
    final bool background_bool = ref
        .read(userSettingsProvider)
        .immichBackgroundImage;

    setState(() {
      backgroundState = background_bool;
    });

    return;
  }

  void isBarOn() {
    final bool naviState = ref.read(userSettingsProvider).navigationBarOn;

    setState(() {
      navbarShown = naviState;
    });

    return;
  }

  void getBarTransparency() {
    final bool naviState = ref
        .read(userSettingsProvider)
        .navigationBarTransparent;

    setState(() {
      navbarShown = naviState;
    });

    return;
  }

  void getInfoAlignment() {
    final bool alignment = ref.read(userSettingsProvider).albumInfoCentered;

    setState(() {
      _currentAlignment = alignment ? 1 : 0;
    });

    return;
  }

  void getBackgroundBlur() {
    final double position = ref.read(userSettingsProvider).backgroundBlur;

    setState(() {
      sliderValue = position;
    });

    return;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: const Text('Immich background image'),
          leading: const Icon(Icons.image),
          subtitle: const Text(
            'Turn on and off the Immich background. When off, the background will be replaced by the cover art.',
          ),
          trailing: Switch(
            value: backgroundState,
            onChanged: (bool value) async {
              AsyncPreferences.setBoolValue('immich_background', value);
              await ref.read(userSettingsProvider.notifier).getNewState();
              setState(() {
                backgroundState = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Background blur'),
          leading: const Icon(Icons.blur_on_rounded),
          enabled: !backgroundState,
          subtitle: SliderTheme(
            data: const SliderThemeData(
              showValueIndicator: ShowValueIndicator.onDrag,
            ),
            child: Slider(
              value: sliderValue,
              max: 128,
              onChanged: !backgroundState
                  ? (double value) {
                      setState(() {
                        sliderValue = value;
                      });
                    }
                  : null,
              onChangeEnd: (double value) async {
                await AsyncPreferences.setDoubleValue(
                  'background_blur_radius',
                  value,
                );
                await ref.read(userSettingsProvider.notifier).getNewState();
              },
              divisions: 32,
              year2023: false,
              padding: const EdgeInsets.all(0),
              label: sliderValue.toString(),
            ),
          ),
        ),
        ListTile(
          title: const Text('Show navigation bar'),
          leading: const Icon(Icons.visibility_rounded),
          subtitle: const Text(
            'Hide the navigation bar at the top of the screen. Pages are still navigable by swiping.',
          ),
          trailing: Switch(
            value: navbarShown,
            onChanged: (bool value) async {
              await AsyncPreferences.setBoolValue('navibar_on', value);
              await ref.read(userSettingsProvider.notifier).getNewState();
              setState(() {
                navbarShown = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Transparent navigation bar'),
          leading: const Icon(Icons.opacity_rounded),
          enabled: navbarShown,
          subtitle: const Text(
            'When on, the navigation bar turns transparent and overlays over the content.',
          ),
          trailing: Switch(
            value: isNavbarTransparent,
            onChanged: navbarShown
                ? (bool value) async {
                    await AsyncPreferences.setBoolValue('transparent_navibar', value);
                    await ref.read(userSettingsProvider.notifier).getNewState();
                    setState(() {
                      isNavbarTransparent = value;
                    });
                  }
                : null,
          ),
        ),
        ListTile(
          title: const Text('Album info position'),
          leading: const Icon(Icons.album_rounded),
          subtitle: const Text(
            'Choose where the album info on the player page should be.',
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Album info position'),
                  content: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return RadioGroup<int>(
                        groupValue: _currentAlignment,
                        onChanged: (int? value) async {
                          await AsyncPreferences.setIntValue(
                            'player_alignment',
                            value!,
                          );
                          await ref.read(userSettingsProvider.notifier).getNewState();
                          setState(() {
                            _currentAlignment = value;
                          });
                        },
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              title: Text('Bottom Left'),
                              leading: Radio<int>(value: 0),
                            ),
                            ListTile(
                              title: Text('Centered'),
                              leading: Radio<int>(value: 1),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                );
              },
            );
          },
        ),
        const BarPositionTile(),
      ],
    );
  }
}

class BarPositionTile extends ConsumerStatefulWidget {
  const BarPositionTile({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BarPositionTileState();
}

class _BarPositionTileState extends ConsumerState<BarPositionTile> {
  int? _currentAppearance = 0;

  @override
  void initState() {
    super.initState();
    getPlaybackBarState();
  }

  void getPlaybackBarState() {
    final int barState = ref.read(userSettingsProvider).playbackBarPosition;

    setState(() {
      _currentAppearance = barState;
    });

    return;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.play_arrow_rounded),
      title: const Text('Playback controls appearance'),
      subtitle: const Text('Change when the playback bar should show up.'),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Playback controls appearance'),
              content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return RadioGroup<int>(
                    groupValue: _currentAppearance,
                    onChanged: (int? value) async {
                      await AsyncPreferences.setIntValue(
                        'playback_bar_position',
                        value!,
                      );
                      await ref.read(userSettingsProvider.notifier).getNewState();
                      setState(() {
                        _currentAppearance = value;
                      });
                    },
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          title: Text('Always show'),
                          leading: Radio<int>(value: 0),
                        ),
                        ListTile(
                          title: Text('Show only on player page'),
                          leading: Radio<int>(value: 1),
                        ),
                        ListTile(
                          title: Text('Never show'),
                          leading: Radio<int>(value: 2),
                        ),
                      ],
                    ),
                  );
                },
              ),

              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
