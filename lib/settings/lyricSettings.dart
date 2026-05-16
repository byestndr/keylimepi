import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotimmich/providers/settings_provider.dart';
import 'package:spotimmich/settings/preferences.dart';

class LyricSettings extends ConsumerStatefulWidget {
  const LyricSettings({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LyricsettiSgsState();
}

class _LyricsettiSgsState extends ConsumerState<LyricSettings> {
  bool romanizationOn = false;

  @override
  void initState() {
    super.initState();
    getRomanizationToggle();
  }

  void getRomanizationToggle() {
    final bool romanizationBool = ref
        .read(userSettingsProvider)
        .isRomanized;

    setState(() {
      romanizationOn = romanizationBool;
    });

    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            title: const Text('Romanize lyrics'),
            leading: const Icon(Icons.image),
            subtitle: const Text(
              'Turns Chinese, Japanese, and Korean languages into their latin character representations.',
            ),
            trailing: Switch(
              value: romanizationOn,
              onChanged: (bool value) async {
                AsyncPreferences.setBoolValue('romanization_on', value);
                await ref.read(userSettingsProvider.notifier).getNewState();
                setState(() {
                  romanizationOn = value;
                });
              },
            ),
          ),
        ],
      ),
      appBar: AppBar(title: const Text('Lyric Settings')),
    );
  }
}
