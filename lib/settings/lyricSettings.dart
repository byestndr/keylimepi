import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotimmich/providers/lyrics/lyrics_provider.dart';
import 'package:spotimmich/providers/settings_provider.dart';
import 'package:spotimmich/settings/preferences.dart';

class LyricSettings extends ConsumerStatefulWidget {
  const LyricSettings({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LyricsettiSgsState();
}

class _LyricsettiSgsState extends ConsumerState<LyricSettings> {
  bool romanizationOn = false;
  double fontSize = 30.0;

  @override
  void initState() {
    super.initState();
    getValues();
  }

  void getValues() {
    final bool romanizationBool = ref.read(userSettingsProvider).isRomanized;
    final double lyricFontSize = ref.read(userSettingsProvider).lyricFontSize;

    setState(() {
      romanizationOn = romanizationBool;
      fontSize = lyricFontSize;
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
                ref.invalidate(lyricsGetterProvider);
              },
            ),
          ),
          ListTile(
            title: const Text('Font Size'),
            leading: const Icon(Icons.font_download_rounded),
            subtitle: Column(
              children: [
                const Text(
                  'Adjust the font size of inactive lines, while active lines are 4dp above this value. Defaults to 30.0',
                ),
                SliderTheme(
                  data: const SliderThemeData(
                    showValueIndicator: ShowValueIndicator.onDrag,
                  ),
                  child: Slider(
                    value: fontSize,
                    max: 36.0,
                    min: 10.0,
                    onChanged: (double value) {
                      setState(() {
                        fontSize = value;
                      });
                    },
                    onChangeEnd: (double value) async {
                      await AsyncPreferences.setDoubleValue(
                        'lyric_font_size',
                        value,
                      );
                      await ref
                          .read(userSettingsProvider.notifier)
                          .getNewState();
                    },
                    divisions: 13,
                    year2023: false,
                    padding: const EdgeInsets.all(0),
                    label: fontSize.toString(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      appBar: AppBar(title: const Text('Lyric Settings')),
    );
  }
}
