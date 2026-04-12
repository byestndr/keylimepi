import 'dart:async';

import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:spotimmich/backend/spotify/spotifyauth.dart';
import 'package:spotimmich/settings/spotify/spotifytokendialog.dart';
import 'package:spotimmich/backend/spotify/spotifyauthserver.dart';

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

Server server = Server();

class SettingsList extends StatelessWidget {
  const SettingsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.person),
          trailing: const Icon(Icons.open_in_new),
          subtitle: const Text(
            'Open the Spotify authorization page and log in.',
          ),
          title: const Text('Log into Spotify'),
          onTap: () {
            launchURL();
          },
        ),
        const AccessToken(),
        ListTile(
          title: const Text('Login via QR code'),
          leading: const Icon(Icons.qr_code_rounded),
          subtitle: const Text('Use another device to log into Spotify'),
          onTap: () async {
            await server.startServer(context);
            unawaited(showQrCodeDialog(context));
          },
        ),
      ],
    );
  }
}

void launchURL() async {
  final String url = SpotifyAuthentication.AuthFlow();
  final Uri parsedUrl = Uri.parse(url);
  if (!await launchUrl(parsedUrl)) {
    throw 'Unable to open authorization page';
  }
}



Future<void> showQrCodeDialog(BuildContext context) async {
  final result = showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder:
            (BuildContext context, void Function(void Function()) setState) {
              return SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: AlertDialog(
                    title: const Text('Login via QR code'),
                    content: SizedBox(
                      width: 300,
                      height: 300,
                      child: QrImageView(
                        data: SpotifyAuthentication.AuthFlow(),
                        backgroundColor: Colors.white,
                        version: QrVersions.auto,
                        size: 300,
                      ),
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
                          Navigator.of(context).pop(true);
                          showQrCodeDirections(context);
                        },
                        child: const Text('Next'),
                      ),
                    ],
                  ),
                ),
              );
            },
      );
    },
  );
  final bool? isNext = await result;

  if (isNext == null) {
    server.stopServer();
  }
}

void showQrCodeDirections(BuildContext context) async {
  final String? localIP = await NetworkInfo().getWifiIP();
  final result = showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, void Function(void Function()) setState) {
          return SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: AlertDialog(
                title: const Text('Login via QR code'),
                content: Column(
                  children: <Widget>[
                    const ListTile(
                      leading: Text(
                        '1.',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      title: Text(
                        'Log into Spotify using the QR code on another device',
                      ),
                    ),
                    ListTile(
                      leading: const Text(
                        '2.',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      title: Text(
                        'Change the redirect url from 127.0.0.1 to $localIP',
                      ),
                      subtitle: Text(
                        'For example, change http://127.0.0.1:8080/... to http://$localIP:8080/...',
                      ),
                    ),
                    const ListTile(
                      leading: Text(
                        '3.',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      title: Text(
                        'Once finished, this dialog will automatically close',
                      ),
                    ),
                  ],
                ),

                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );

  await result;
  server.stopServer();
}
