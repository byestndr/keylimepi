import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:spotimmich/settings/spotify/spotifyauth.dart';
import 'package:spotimmich/settings/spotify/spotifytokendialog.dart';

class SpotifyPage extends StatelessWidget {
  const SpotifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SettingsList(),
      appBar: AppBar(title: const Text('Spotify Settings')),
    );
  }
}

class SettingsList extends StatelessWidget {
  const SettingsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.person),
          trailing: const Icon(Icons.open_in_new),
          subtitle: const Text('Open the Spotify authorization page and log in.'),
          title: const Text('Log into Spotify'),
          onTap: () {
            launchURL();
          },
        ),
        const AccessToken(),
      ],
    );
  }
}

void launchURL() async {
  final String url = AuthFlow();
  final Uri parsedUrl = Uri.parse(url);
  if (!await launchUrl(parsedUrl)) {
    throw 'Unable to open authorization page';
  }
}
