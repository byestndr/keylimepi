import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:spotimmich/backend/spotify/spotify_authentication.dart';

class AccessToken extends StatefulWidget {
  const AccessToken({super.key});

  @override
  State<AccessToken> createState() => _AccessTokenState();
}

class _AccessTokenState extends State<AccessToken> {
  final TextEditingController URLtextField = TextEditingController();
  String? errorTextField;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    URLtextField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.key),
      subtitle: const Text('Enter the redirect URL to successfully login.'),
      title: const Text('Spotify access token'),
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
                            setState(() {
                              errorTextField = null;
                            });
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            final SpotifyAuthenticationService
                            authenticationService =
                                SpotifyAuthenticationService.create();
                            final Response authenticatorResponse =
                                await authenticationService.getNewAccessToken(
                                  URLtextField.text,
                                );

                            if (authenticatorResponse.isSuccessful) {
                              Navigator.of(context).pop();
                            } else {
                              setState(() {
                                errorTextField =
                                    'Please retry authentication and paste its redirect link again.';
                              });
                            }
                          },
                          child: const Text('Next'),
                        ),
                      ],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(20),
                      ),
                      content: SizedBox.square(
                        child: Column(
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsetsGeometry.directional(
                                top: 15.0,
                              ),
                            ),
                            const Icon(Icons.key, size: 60.0),
                            const Text(
                              'Access Token',
                              style: TextStyle(fontSize: 30.0),
                            ),
                            const SizedBox(
                              width: 380.0,
                              child: Text(
                                'After logging in with the previous link, copy the redirected page\'s URL and enter it into the field below.',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsetsGeometry.directional(
                                top: 10.0,
                              ),
                            ),
                            SizedBox(
                              width: 420.0,
                              child: TextField(
                                controller: URLtextField,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  label: const Text('Redirect URL'),
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
