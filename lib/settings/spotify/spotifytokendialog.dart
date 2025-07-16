import 'package:flutter/material.dart';
import 'spotifyauth.dart';

class AccessToken extends StatefulWidget {
  const AccessToken({super.key});

  @override
  State<AccessToken> createState() => _AccessTokenState();
}

class _AccessTokenState extends State<AccessToken> {
  final URLtextField = TextEditingController();
  String? errorTextField = null;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    URLtextField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.key),
      trailing: Icon(Icons.open_in_new),
      subtitle: Text('Enter the redirect URL to successfully login.'),
      title: Text('Spotify access token'),
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
                            setState(() {
                              errorTextField = null;
                            });
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            GetAccessToken(URLtextField.text).then((value) {
                              if (value == 200) {
                                Navigator.of(context).pop();
                              } else {
                                setState(() {
                                  errorTextField =
                                      'Please retry authentication and paste its redirect link again.';
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
                            Text(
                              'Access Token',
                              style: TextStyle(fontSize: 30.0),
                            ),
                            SizedBox(
                              width: 380.0,
                              child: Text(
                                'After logging in with the previous link, copy the redirected page\'s URL and enter it into the field below.',
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
                                controller: URLtextField,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  label: Text('Redirect URL'),
                                  errorText: errorTextField,
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
