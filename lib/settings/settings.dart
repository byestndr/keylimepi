import 'package:flutter/material.dart';
import 'package:spotimmich/settings/immich/immichpage.dart';
import 'package:spotimmich/settings/spotify/spotifyauth.dart';
import 'package:spotimmich/settings/spotify/spotifypage.dart';
import 'package:spotimmich/settings/weatherdialog.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SettingsList(),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
    );
  }
}

class SettingsList extends StatelessWidget {
  const SettingsList({super.key});
  static const SnackBar resetSnackBar = SnackBar(content: Text('Reseted all settings'));

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.music_note_rounded),
          title: Text('Spotify Settings'),
          subtitle: Text('Authorize Spotify and configure settings.'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context) => const SpotifyPage()),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.image),
          title: Text('Immich Settings'),
          subtitle: Text('Authorize and configure Immich settings.'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context) => const ImmichPage()),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.sunny),
          title: Text('Weather Location'),
          subtitle: Text('Choose a weather location to show in the player'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context) => const WeatherLocation()),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.delete),
          title: Text('Reset Settings'),
          subtitle: Text(
            'Delete all data from shared preferences. Includes authorizations.',
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Reset Settings'),
                  content: Text(
                    'Are you sure you want reset all data? This includes all authorizations and settings saved.'
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        preferences().ClearPreferences();
                        ScaffoldMessenger.of(context).showSnackBar(resetSnackBar);
                        Navigator.of(context).pop();
                      },
                      child: Text('Confirm'),
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
