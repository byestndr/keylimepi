import 'package:http/http.dart' as http;

Future<String> geocode(String location) async {
  final Map<String, String> params = {
    'name': '$location',
    'count': '20',
    'language': 'en',
    'format': 'json',
  };
  final Uri uri = Uri.https(
    'geocoding-api.open-meteo.com',
    'v1/search',
    params,
  );

  final http.Response response = await http.get(uri);

  return response.body;
}

Future<String> weather(double latitude, double longitude) async {
  final Map<String, String> params = {
    'latitude': '$latitude',
    'longitude': '$longitude',
    'current': 'temperature_2m,weather_code',
    'temperature_unit': 'fahrenheit',
  };
  final Uri uri = Uri.https('api.open-meteo.com', 'v1/forecast', params);

  final http.Response response = await http.get(uri);

  return response.body;
}
