import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotimmich/providers/background_getter.dart';
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
  bool state = false;
  int? _currentAlignment = 1;
  double sliderValue = 0;

  @override
  void initState() {
    super.initState();
    getBackgroundToggle();
    getAlignment();
    getSliderPos();
  }

  Future<void> getBackgroundToggle() async {
    final bool? background_bool = await AsyncPreferences().getBoolValue(
      'immich_background',
    );
    if (background_bool == null) {
      setState(() {
        state = false;
      });
    } else {
      setState(() {
        state = background_bool;
      });
    }

    return;
  }

  Future<void> getAlignment() async {
    final int? alignment = await AsyncPreferences().getIntValue(
      'player_alignment',
    );

    if (alignment == null) {
      setState(() {
        _currentAlignment = 0;
      });
    } else {
      setState(() {
        _currentAlignment = alignment;
      });
    }

    return;
  }

  Future<void> getSliderPos() async {
    final double? position = await AsyncPreferences().getDoubleValue(
      'background_blur_radius',
    );

    if (position == null) {
      setState(() {
        sliderValue = 0;
      });
    } else {
      setState(() {
        sliderValue = position;
      });
    }

    return;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text('Immich background image'),
          leading: const Icon(Icons.image),
          subtitle: const Text(
            'Turn on and off the Immich background. When off, the background will be replaced by the cover art.',
          ),
          trailing: Switch(
            value: state,
            onChanged: (bool value) async {
              AsyncPreferences().setBoolValue('immich_background', value);
              await ref.read(sharedPrefsProvider).reloadCache();
              setState(() {
                state = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Background blur'),
          leading: const Icon(Icons.blur_on_rounded),
          enabled: !state,
          subtitle: SliderTheme(
            data: const SliderThemeData(
              showValueIndicator: ShowValueIndicator.onDrag,
            ),
            child: Slider(
              value: sliderValue,
              max: 128,
              onChanged: !state
                  ? (double value) {
                      setState(() {
                        sliderValue = value;
                      });
                    }
                  : null,
              onChangeEnd: (double value) async {
                await AsyncPreferences().setDoubleValue(
                  'background_blur_radius',
                  value,
                );
              },
              divisions: 8,
              year2023: false,
              padding: const EdgeInsets.all(0),
              label: sliderValue.toString(),
            ),
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
                        onChanged: (int? value) {
                          AsyncPreferences().setIntValue(
                            'player_alignment',
                            value!,
                          );
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
        const BarPositionTile()
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


  Future<void> getPlaybackBarState() async {
    final int? barState = await AsyncPreferences().getIntValue(
      'playback_bar_position',
    );

    if (barState == null) {
      setState(() {
        _currentAppearance = 0;
      });
    } else {
      setState(() {
        _currentAppearance = barState;
      });
    }

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
                    onChanged: (int? value) {
                      AsyncPreferences().setIntValue(
                        'playback_bar_position',
                        value!,
                      );
                      setState(() {
                        _currentAppearance = value;
                      });

                      ref.read(barPositionProvider.notifier).changeCurrentPosition(value);
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
