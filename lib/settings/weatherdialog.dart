import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:key_limepi/settings/weatherrequest.dart';

class WeatherLocation extends StatefulWidget {
  const WeatherLocation({super.key});

  @override
  State<WeatherLocation> createState() => _WeatherLocationState();
}

class _WeatherLocationState extends State<WeatherLocation> {
  final TextEditingController LocationField = TextEditingController();

  List<dynamic> items = <dynamic>[
    <String, String>{'name': '', 'admin1': '', 'country': ''},
  ];

  SnackBar confirmationSnackbar(String location) =>
      SnackBar(content: Text('Set current location to $location'));

  Future<void> GetLocations(String location) async {
    final String response = await geocode(location);
    final dynamic body = jsonDecode(response);

    final dynamic result = body['results'];
    setState(() {
      items = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(items[index]['name']),
            subtitle: Text(
              '${items[index]['admin1']}, ${items[index]['country']}',
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm location'),
                    content: Text(
                      'The chosen location is ${items[index]['name']}, ${items[index]['country']}',
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
                          Navigator.of(context).pop();
                          WeatherPreferences().saveLocation(
                            items[index]['latitude'],
                            items[index]['longitude'],
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            confirmationSnackbar(items[index]['name']),
                          );
                        },
                        child: const Text('Confirm'),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
      appBar: AppBar(
        centerTitle: true,
        title: TextField(
          controller: LocationField,
          decoration: InputDecoration(
            hintText: 'Search weather locations',
            suffixIcon: IconButton(
              onPressed: () {
                GetLocations(LocationField.text);
              },
              icon: const Icon(Icons.search),
            ),
          ),
          onSubmitted: (String value) {
            GetLocations(LocationField.text);
          },
        ),
      ),
    );
  }
}

class WeatherPreferences {
  final SharedPreferencesAsync prefs = SharedPreferencesAsync();
  Future<void> saveLocation(double latitude, double longitude) async {
    await prefs.remove('latitude');
    await prefs.remove('longitude');
    await prefs.setDouble('latitude', latitude);
    await prefs.setDouble('longitude', longitude);
  }

  Future<double?> getLatitude() async {
    final double? latitude = await prefs.getDouble('latitude');
    return latitude;
  }

  Future<double?> getLongitude() async {
    final double? longitude = await prefs.getDouble('longitude');
    return longitude;
  }
}
