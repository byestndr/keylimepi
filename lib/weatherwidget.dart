import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:spotimmich/settings/weatherdialog.dart';
import 'dart:async';

import 'package:spotimmich/settings/weatherrequest.dart';

class Weatherwidget extends StatefulWidget {
  const Weatherwidget({super.key});

  @override
  State<Weatherwidget> createState() => _WeatherwidgetState();
}

class _WeatherwidgetState extends State<Weatherwidget> {
  Timer? timer;
  int temperature = 0;
  String condition = 'No data';
  IconData conditionIcon = Icons.sunny;
  late int roundedTemperature;

  static const Map<int, Map<String, dynamic>> codeToCondition = {
    0: {'Condition': 'Clear sky', 'Icon': Icons.sunny},
    1: {'Condition': 'Mostly clear', 'Icon': Icons.wb_cloudy_outlined},
    2: {'Condition': 'Partly cloudy', 'Icon': Icons.wb_cloudy_outlined},
    3: {'Condition': 'Overcast', 'Icon': Icons.cloud},

    // Fog and Deposit of Ice
    45: {'Condition': 'Fog', 'Icon': Icons.foggy},
    48: {'Condition': 'Depositing rime fog', 'Icon': Icons.cloudy_snowing},
    // Drizzle
    51: {'Condition': 'Light drizzle', 'Icon': Icons.water_drop_outlined},
    53: {'Condition': 'Moderate drizzle', 'Icon': Icons.water_drop},
    55: {'Condition': 'Dense drizzle', 'Icon': Icons.water_drop_sharp},

    // Rain
    56: {'Condition': 'Light freezing drizzle', 'Icon': Icons.cloudy_snowing},
    57: {'Condition': 'Dense freezing drizzle', 'Icon': Icons.cloudy_snowing},
    61: {'Condition': 'Slight rain', 'Icon': Icons.water_drop_outlined},
    63: {'Condition': 'Moderate rain', 'Icon': Icons.water_drop_rounded},
    65: {'Condition': 'Heavy rain', 'Icon': Icons.water_drop_sharp},
    66: {'Condition': 'Light freezing rain', 'Icon': Icons.cloudy_snowing},
    67: {'Condition': 'Heavy freezing rain', 'Icon': Icons.cloudy_snowing},

    // Snow
    71: {'Condition': 'Slight snowfall', 'Icon': Icons.snowing},
    73: {'Condition': 'Moderate snowfall', 'Icon': Icons.snowing},
    75: {'Condition': 'Heavy snowfall', 'Icon': Icons.snowing},
    77: {'Condition': 'Snow grains', 'Icon': Icons.grain},

    // Showers
    80: {'Condition': 'Slight rain showers', 'Icon': Icons.shower},
    81: {'Condition': 'Moderate rain showers', 'Icon': Icons.shower},
    82: {'Condition': 'Violent rain showers', 'Icon': Icons.thunderstorm},
    85: {'Condition': 'Slight snow showers', 'Icon': Icons.cloudy_snowing},
    86: {'Condition': 'Heavy snow showers', 'Icon': Icons.cloudy_snowing},

    // Thunderstorm
    95: {'Condition': 'Thunderstorm', 'Icon': Icons.thunderstorm},
    96: {
      'Condition': 'Thunderstorm with slight hail',
      'Icon': Icons.thunderstorm,
    },
    99: {
      'Condition': 'Thunderstorm with heavy hail',
      'Icon': Icons.thunderstorm,
    },
  };

  @override
  void initState() {
    super.initState();
    RefreshLoop();

    timer = Timer.periodic(const Duration(minutes: 30), (Timer timer) {
      RefreshLoop();
    });
  }

  void RefreshLoop() async {
    final double? latitude = await WeatherPreferences().GetLatitude();
    final double? longitude = await WeatherPreferences().GetLongitude();

    final response = await weather(latitude, longitude);
    final body = jsonDecode(response);

    try {
      final nonRounded = body['current']['temperature_2m'];
      roundedTemperature = nonRounded.round();
    } on NoSuchMethodError {
      roundedTemperature = 0;
      return;
    }


    int currentWeatherCode = body['current']['weather_code'];
    String? currentCondition =
        codeToCondition[currentWeatherCode]!['Condition'];

    setState(() {
      temperature = roundedTemperature;

      conditionIcon = codeToCondition[currentWeatherCode]!['Icon'];

      if (currentCondition == null) {
        condition = 'No data';
      } else {
        condition = currentCondition;
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(conditionIcon, size: 50, color: Colors.white70),
          Column(
            spacing: 0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform.translate(
                offset: Offset(0, 4),
                child: Text(
                  '${temperature.toString()}°',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                ),
              ),
              Transform.translate(
                offset: Offset(0, -2),
                child: Text(
                  condition,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
