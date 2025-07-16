import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'spotifyauth.dart';
import 'spotifytokendialog.dart';

class SpotifyPage extends StatelessWidget {
  const SpotifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SettingsList(),
      appBar: AppBar(title: Text('Spotify Settings')),
    );
  }
}

class SettingsList extends StatelessWidget {
  const SettingsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.person),
          trailing: Icon(Icons.open_in_new),
          subtitle: Text('Open the Spotify authorization page and log in.'),
          title: Text('Log into Spotify'),
          onTap: () {
            launchURL();
          },
        ),
        AccessToken(),
      ],
    );
  }
}

void launchURL() async {
  final String url = AuthFlow();
  final Uri _url = Uri.parse(url);
  if (!await launchUrl(_url)) {
    throw 'Unable to open authorization page';
  }
}
