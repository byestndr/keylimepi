import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotimmich/pages/authentication_setup_page.dart';
import 'package:spotimmich/providers/settings_provider.dart';
import 'package:spotimmich/providers/spotify/spotify_playbackstate.dart';
import 'package:spotimmich/settings/appearancepage.dart';
import 'package:spotimmich/settings/immich/immichpage.dart';
import 'package:spotimmich/settings/preferences.dart';
import 'package:spotimmich/settings/spotify/spotifypage.dart';
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

class SettingsList extends ConsumerWidget {
  const SettingsList({super.key});
  static const SnackBar resetSnackBar = SnackBar(
    content: Text('Reseted all settings'),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.palette_rounded),
          title: const Text('Appearance'),
          subtitle: const Text('Control the app\'s look'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const AppearancePage(),
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.music_note_rounded),
          title: const Text('Spotify Settings'),
          subtitle: const Text('Authorize Spotify and configure settings.'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const SpotifyPage(),
              ),
            );
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
                      onPressed: () async {
                        await AsyncPreferences.clearPreferences();
                        await SpotifySecureStorage().deleteData();
                        await ref
                            .read(userSettingsProvider.notifier)
                            .getNewState();
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(resetSnackBar);
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const AuthenticationSetupPage(),
                          ),
                        );
                        ref
                            .read(spotifyAuthenticatedProvider.notifier)
                            .setFalse();
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
