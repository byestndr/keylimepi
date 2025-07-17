import 'package:spotimmich/settings/immich/immichpreferences.dart';
import 'package:flutter/material.dart';

class ImmichServer extends StatefulWidget {
  const ImmichServer({super.key});

  @override
  State<ImmichServer> createState() => _ImmichServerState();
}

class _ImmichServerState extends State<ImmichServer> {
  final TextEditingController URLField = TextEditingController();
  String? errorText;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    URLField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.public),
      subtitle: const Text('Enter the redirect URL to successfully login.'),
      title: const Text('Immich Server Location'),
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
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            ImmichPreferences().SetServerURL(URLField.text);
                            Navigator.of(context).pop();
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
                            const Icon(Icons.public, size: 60.0),
                            const Text(
                              'Immich URL',
                              style: TextStyle(fontSize: 30.0),
                            ),
                            const SizedBox(
                              width: 380.0,
                              child: Text(
                                'Enter the URL of your Immich server to fetch background images. Must be https.',
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
                                controller: URLField,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  label: const Text('Server URL'),
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
