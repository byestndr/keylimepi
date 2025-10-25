import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  @override
  void initState() {
    super.initState();
    getBackgroundToggle();
    getAlignment();
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
    final int? alignment = await AsyncPreferences().getIntValue('player_alignment');

    if (alignment == null) {
      setState(() {
        print('null');
        _currentAlignment = 0;
      });
    } else {
      setState(() {
        _currentAlignment = alignment;
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
          title: const Text('Album info position'),
          leading: const Icon(Icons.image),
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
                          AsyncPreferences().setIntValue('player_alignment', value!);
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
      ],
    );
  }
}
