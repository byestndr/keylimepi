import 'package:flutter/material.dart';
import 'package:spotimmich/settings/immich/immichalbumdialog.dart';
import 'package:spotimmich/settings/immich/immichtokendialog.dart';
import 'immichserverdialog.dart';

class ImmichPage extends StatelessWidget {
  const ImmichPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SettingsList(),
      appBar: AppBar(title: Text('Immich Settings')),
    );
  }
}

class SettingsList extends StatelessWidget {
  const SettingsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ImmichServer(),
        ImmichToken(),
        AlbumID(),
      ],
    );
  }
}
