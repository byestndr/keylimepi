import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ImmichToken extends StatefulWidget {
  const ImmichToken({super.key});

  @override
  State<ImmichToken> createState() => _ImmichTokenState();
}

class _ImmichTokenState extends State<ImmichToken> {
  final APIkeyField = TextEditingController();
  String? errorText;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    APIkeyField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.key),
      subtitle: Text('Enter an API key to show background images.'),
      title: Text('Immich API Key'),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (context, setState) {
                return SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: AlertDialog(
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            immichPreferences().SetAPIkey(APIkeyField.text).then((
                              value,
                            ) {
                              if (value == 200) {
                                Navigator.of(context).pop();
                              } else if (value == 404) {
                                setState(() {
                                  errorText =
                                      "No server URL has been entered yet, please enter that first";
                                });
                              } else {
                                setState(() {
                                  errorText =
                                      "Invalid API Key, make sure that it's correct";
                                });
                              }
                            });
                          },
                          child: Text('Next'),
                        ),
                      ],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(20),
                      ),
                      content: SizedBox.square(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsetsGeometry.directional(
                                top: 15.0,
                              ),
                            ),
                            Icon(Icons.key, size: 60.0),
                            Text('API Key', style: TextStyle(fontSize: 30.0)),
                            SizedBox(
                              width: 380.0,
                              child: Text(
                                'Create an API Key and paste it below.',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsGeometry.directional(
                                top: 10.0,
                              ),
                            ),
                            SizedBox(
                              width: 420.0,
                              child: TextField(
                                controller: APIkeyField,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  label: Text('API Key'),
                                  errorText: errorText,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class immichPreferences {
  final SharedPreferencesAsync prefs = SharedPreferencesAsync();
  Future<int> SetAPIkey(String key) async {
    final String? serverURL = await GetURL();

    if (serverURL == null) {
      return 404;
    }

    final Uri uri = Uri.https(serverURL, 'api/search/random');

    final data = jsonEncode({
      "albumIds": ["f39a6a14-82d9-4c49-9c35-6c09603d46aa"],
      "size": 1,
      "type": "IMAGE",
    });

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'x-api-key': key,
      },
      body: data,
    );

    if (response.statusCode == 200) {
      await prefs.remove('immich_key');
      await prefs.setString('immich_key', key);
      return 200;
    } else {
      return 401;
    }
  }

  Future<String?> GetAPIkey() async {
    final String? key = await prefs.getString('immich_key');
    return key;
  }

  void SetServerURL(String url) async {
    final String noHttps = url.replaceAll('https://', '');
    String cleanURL = noHttps.replaceAll(RegExp(r'\/.*'), '');
    await prefs.remove('immich_url');
    await prefs.setString('immich_url', cleanURL);
  }

  Future<String?> GetURL() async {
    final String? url = await prefs.getString('immich_url');
    return url;
  }

  void SetAlbumID(id) async {
    await prefs.remove('immich_album');
    await prefs.setString('immich_album', id);
  }

  Future<String?> GetAlbumID() async {
    final String? album = await prefs.getString('immich_album');
    return album;
  }
}

Future<dynamic> getBackgroundImage() async {
  final apikey = await immichPreferences().GetAPIkey();
  if (apikey == null) {
    return AssetImage('assets/imagePlaceholder.png');
  }

  String? serverURL = await immichPreferences().GetURL();

  if (serverURL == null) {
    return AssetImage('assets/imagePlaceholder.png');
  }

  String? albumID = await immichPreferences().GetAlbumID();

  final Uri uri = Uri.https(serverURL, 'api/search/random');
  var data = jsonEncode({"size": 1, "type": "IMAGE"});

  if (albumID != null) {
    data = jsonEncode({
      "albumIds": ["$albumID"],
      "size": 1,
      "type": "IMAGE",
    });
  }

  try {
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'x-api-key': apikey,
      },
      body: data,
    );
    final body = jsonDecode(response.body);
    final String id = body[0]["id"];

    final String backgroundImage = "https://$serverURL/api/assets/$id/original";
    return NetworkImage(
        backgroundImage,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'x-api-key': apikey,
        },
      );
  } on HandshakeException {
    return AssetImage('assets/imagePlaceholder.png');
  }
}
