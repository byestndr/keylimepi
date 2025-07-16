import 'immichtokendialog.dart';
import 'package:flutter/material.dart';

class AlbumID extends StatefulWidget {
  const AlbumID({super.key});

  @override
  State<AlbumID> createState() => _AlbumIDState();
}

class _AlbumIDState extends State<AlbumID> {
  final AlbumField = TextEditingController();
  String? errorText;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    AlbumField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.image),
      subtitle: Text('Enter an album ID to randomly choose pictures from.'),
      title: Text('Background Album'),
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
                            immichPreferences().SetAlbumID(AlbumField.text);
                            Navigator.of(context).pop();
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
                            Icon(Icons.image, size: 60.0),
                            Text('Album ID', style: TextStyle(fontSize: 30.0)),
                            SizedBox(
                              width: 380.0,
                              child: Text(
                                'Enter an album ID to pick photos from. Leave empty to pick from the whole library',
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
                                controller: AlbumField,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  label: Text('Album ID'),
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
