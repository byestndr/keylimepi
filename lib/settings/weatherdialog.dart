import 'dart:convert';
import 'dart:ffi';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:spotimmich/settings/weatherrequest.dart';

class WeatherLocation extends StatefulWidget {
  const WeatherLocation({super.key});

  @override
  State<WeatherLocation> createState() => _WeatherLocationState();
}

class _WeatherLocationState extends State<WeatherLocation> {
  final LocationField = TextEditingController();

  List items = [
    {'name': '', 'admin1': '', 'country': ''},
  ];

  SnackBar confirmationSnackbar(String location) =>
      SnackBar(content: Text('Set current location to $location'));

  void GetLocations(String location) async {
    final response = await geocode(location);
    final body = jsonDecode(response);

    final result = body['results'];
    setState(() {
      items = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
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
                    title: Text('Confirm location'),
                    content: Text(
                      'The chosen location is ${items[index]['name']}, ${items[index]['country']}',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          WeatherPreferences().SaveLocation(
                            items[index]['latitude'],
                            items[index]['longitude'],
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            confirmationSnackbar(items[index]['name']),
                          );
                        },
                        child: Text('Confirm'),
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
              icon: Icon(Icons.search),
            ),
          ),
          onSubmitted: (value) {
            GetLocations(LocationField.text);
          },
        ),
      ),
    );
  }
}

class WeatherPreferences {
  final SharedPreferencesAsync prefs = SharedPreferencesAsync();
  void SaveLocation(double latitude, double longitude) async {
    await prefs.remove('latitude');
    await prefs.remove('longitude');
    await prefs.setDouble('latitude', latitude);
    await prefs.setDouble('longitude', longitude);
  }

  Future<double?> GetLatitude() async {
    final double? latitude = await prefs.getDouble('latitude');
    return latitude;
  }

  Future<double?> GetLongitude() async {
    final double? longitude = await prefs.getDouble('longitude');
    return longitude;
  }
}
