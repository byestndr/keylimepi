import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:spotimmich/settings/preferences.dart';
import 'package:http/http.dart' as http;

class ImmichPreferences {
  Future<int> SetAPIkey(String key) async {
    final String? serverURL = await GetURL();

    if (serverURL == null) {
      return 404;
    }

    final Uri uri = Uri.https(serverURL, 'api/search/random');

    final String data = jsonEncode(<String, Object>{
      "size": 1,
      "type": "IMAGE",
    });

    final http.Response response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'x-api-key': key,
      },
      body: data,
    );

    if (response.statusCode == 200) {
      await AsyncPreferences.setStringValue('immich_key', key);
      return 200;
    } else {
      return 401;
    }
  }

  Future<String?> GetAPIkey() async {
    final String? key = await AsyncPreferences.getStringValue('immich_key');
    return key;
  }

  Future<void> SetServerURL(String url) async {
    final String noHttps = url.replaceAll('https://', '');
    String cleanURL = noHttps.replaceAll(RegExp(r'\/.*'), '');
    await AsyncPreferences.setStringValue('immich_url', cleanURL);
  }

  Future<String?> GetURL() async {
    final String? url = await AsyncPreferences.getStringValue('immich_url');
    return url;
  }

  Future<void> SetAlbumID(String id) async {
    await AsyncPreferences.getStringValue('immich_album');
  }

  Future<String?> GetAlbumID() async {
    final String? album = await AsyncPreferences.getStringValue('immich_album');
    return album;
  }
}

Future<Image> getBackgroundImage(double pixelRatio) async {
  final String? apikey = await ImmichPreferences().GetAPIkey();
  if (apikey == null) {
    return Image.asset('assets/imagePlaceholder.png');
  }

  String? serverURL = await ImmichPreferences().GetURL();

  if (serverURL == null) {
    return Image.asset('assets/imagePlaceholder.png');
  }

  String? albumID = await ImmichPreferences().GetAlbumID();

  final Uri uri = Uri.https(serverURL, 'api/search/random');
  String data = jsonEncode(<String, Object>{"size": 1, "type": "IMAGE"});

  if (albumID != null) {
    data = jsonEncode(<String, Object>{
      "albumIds": <String>["$albumID"],
      "size": 1,
      "type": "IMAGE",
    });
  }

  try {
    final http.Response response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'x-api-key': apikey,
      },
      body: data,
    );
    final dynamic body = jsonDecode(response.body);
    final String id = body[0]["id"];

    final String backgroundImage = "https://$serverURL/api/assets/$id/original";
    return Image.network(
        backgroundImage,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'x-api-key': apikey,
        },
        cacheWidth: (1000 * pixelRatio).toInt(),
      );
  } on HandshakeException {
    return Image.asset('assets/imagePlaceholder.png');
  }
}