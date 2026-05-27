import 'package:flutter/material.dart';
import 'package:key_limepi/settings/immich/immichalbumdialog.dart';
import 'package:key_limepi/settings/immich/immichtokendialog.dart';
import 'package:key_limepi/settings/immich/immichserverdialog.dart';

class ImmichPage extends StatelessWidget {
  const ImmichPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SettingsList(),
      appBar: AppBar(title: const Text('Immich Settings')),
    );
  }
}

class SettingsList extends StatelessWidget {
  const SettingsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const <Widget>[
        ImmichServer(),
        ImmichToken(),
        AlbumID(),
      ],
    );
  }
}
