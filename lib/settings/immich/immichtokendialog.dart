import 'package:flutter/material.dart';
import 'package:spotimmich/settings/immich/immichpreferences.dart';

class ImmichToken extends StatefulWidget {
  const ImmichToken({super.key});

  @override
  State<ImmichToken> createState() => _ImmichTokenState();
}

class _ImmichTokenState extends State<ImmichToken> {
  final TextEditingController APIkeyField = TextEditingController();
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
              builder: (BuildContext context, setState) {
                return SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: AlertDialog(
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            ImmichPreferences().SetAPIkey(APIkeyField.text).then((
                              int value,
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
                          children: <Widget>[
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


