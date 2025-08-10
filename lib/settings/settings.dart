import 'package:flutter/material.dart';
import 'package:spotimmich/settings/immich/immichpage.dart';
import 'package:spotimmich/settings/spotify/spotifyauth.dart';
import 'package:spotimmich/settings/weatherdialog.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SettingsList(),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
    );
  }
}

class SettingsList extends StatelessWidget {
  const SettingsList({super.key});
  static const SnackBar resetSnackBar = SnackBar(
    content: Text('Reseted all settings'),
  );
  static const SnackBar spotifyConfirmation = SnackBar(
    content: Text('Logged into Spotify'),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.music_note_rounded),
          title: const Text('Authorize Spotify'),
          subtitle: const Text('Log into Spotify.'),
          onTap: () {
            AuthFlow().then((int statusCode) {
              if (statusCode >= 400) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Error'),
                      content: const Text(
                        'There was a problem logging into Spotify, please try again.',
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(spotifyConfirmation);
              }
            });
          },
        ),
        ListTile(
          leading: const Icon(Icons.image),
          title: const Text('Immich Settings'),
          subtitle: const Text('Authorize and configure Immich settings.'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const ImmichPage(),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.sunny),
          title: const Text('Weather Location'),
          subtitle: const Text(
            'Choose a weather location to show in the player',
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const WeatherLocation(),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.delete),
          title: const Text('Reset Settings'),
          subtitle: const Text(
            'Delete all data from shared preferences. Includes authorizations.',
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Reset Settings'),
                  content: const Text(
                    'Are you sure you want reset all data? This includes all authorizations and settings saved.',
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        preferences().ClearPreferences();
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(resetSnackBar);
                        Navigator.of(context).pop();
                      },
                      child: const Text('Confirm'),
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
