import 'package:flutter/material.dart';
import 'package:spotimmich/settings/spotify/spotifyauth.dart';

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

class SettingsList extends StatefulWidget {
  const SettingsList({super.key});

  @override
  State<SettingsList> createState() => _SettingsListState();
}

class _SettingsListState extends State<SettingsList> {
  bool state = false;

  @override
  void initState() {
    super.initState();
    getBackgroundToggle();
  }

  Future<void> getBackgroundToggle() async {
    final bool? background_bool = await preferences().getBoolValue('immich_background');
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text('Immich Background Image'),
          leading: const Icon(Icons.image),
          subtitle: const Text(
            'Turn on and off the Immich background. When off, the background will be replaced by the cover art.',
          ),
          trailing: Switch(value: state, onChanged: (bool value) {
            preferences().setBoolValue('immich_background', value);
            setState(() {
              state = value;
            });
          },),
        ),
      ],
    );
  }
}
