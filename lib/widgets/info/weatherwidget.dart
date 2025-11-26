import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:spotimmich/settings/weatherdialog.dart';
import 'dart:async';

import 'package:spotimmich/settings/weatherrequest.dart';


enum WeatherCodeEnum {
  clearSky(0, 'Clear sky', Icons.sunny),
  mostlyClear(1, 'Mostly clear', Icons.wb_cloudy_outlined),
  partlyCloudy(2, 'Partly cloudy', Icons.wb_cloudy_outlined),
  overcast(3, 'Overcast', Icons.cloud),

  // Fog
  fog(45, 'Fog', Icons.foggy),
  depositingRimeFog(48, 'Depositing rime fog', Icons.cloudy_snowing),

  // Drizzle
  lightDrizzle(51, 'Light drizzle', Icons.water_drop_outlined),
  moderateDrizzle(53, 'Moderate drizzle', Icons.water_drop),
  denseDrizzle(55, 'Dense drizzle', Icons.water_drop_sharp),
  lightFreezingDrizzle(56, 'Light freezing drizzle', Icons.cloudy_snowing),
  denseFreezingDrizzle(57, 'Dense freezing drizzle', Icons.cloudy_snowing),

  // Rain
  slightRain(61, 'Slight rain', Icons.water_drop_outlined),
  moderateRain(63, 'Moderate rain', Icons.water_drop_rounded),
  heavyRain(65, 'Heavy rain', Icons.water_drop_sharp),
  lightFreezingRain(66, 'Light freezing rain', Icons.cloudy_snowing),
  heavyFreezingRain(67, 'Heavy freezing rain', Icons.cloudy_snowing),

  // Snow
  slightSnowfall(71, 'Slight snowfall', Icons.snowing),
  moderateSnowfall(73, 'Moderate snowfall', Icons.snowing),
  heavySnowfall(75, 'Heavy snowfall', Icons.snowing),
  snowGrains(77, 'Snow grains', Icons.grain),

  // Showers
  slightRainShowers(80, 'Slight rain showers', Icons.shower),
  moderateRainShowers(81, 'Moderate rain showers', Icons.shower),
  violentRainShowers(82, 'Violent rain showers', Icons.thunderstorm),
  slightSnowShowers(85, 'Slight snow showers', Icons.cloudy_snowing),
  heavySnowShowers(86, 'Heavy snow showers', Icons.cloudy_snowing),

  // Thunderstorm
  thunderstorm(95, 'Thunderstorm', Icons.thunderstorm),
  thunderstormSlightHail(96, 'Thunderstorm with slight hail', Icons.thunderstorm),
  thunderstormHeavyHail(99, 'Thunderstorm with heavy hail', Icons.thunderstorm);
  
  final int code;
  final String description;
  final IconData icon;

  const WeatherCodeEnum(this.code, this.description, this.icon);

  static WeatherCodeEnum codeToCondition(int code) {
    for (final WeatherCodeEnum condition in values) {
      if (condition.code == code) {
        return condition;
      }
    }
    return clearSky;
  }
  
  }


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

  @override
  void initState() {
    super.initState();
    RefreshLoop();

    timer = Timer.periodic(const Duration(minutes: 30), (Timer timer) {
      RefreshLoop();
    });
  }

  Future<void> RefreshLoop() async {
    final double? latitude = await WeatherPreferences().getLatitude();
    final double? longitude = await WeatherPreferences().getLongitude();

    if (latitude == null || longitude == null) {
      return;
    }

    final String response = await weather(latitude, longitude);
    final dynamic body = jsonDecode(response);

    try {
      final double nonRounded = body['current']['temperature_2m'];
      roundedTemperature = nonRounded.round();
    } on NoSuchMethodError {
      roundedTemperature = 0;
      return;
    }


    int currentWeatherCode = body['current']['weather_code'];
    String? currentCondition =
        WeatherCodeEnum.codeToCondition(currentWeatherCode).description;

    if (!mounted) {
      return;
    }
    
    setState(() {
      temperature = roundedTemperature;

      conditionIcon = WeatherCodeEnum.codeToCondition(currentWeatherCode).icon;
      condition = currentCondition;
      
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(conditionIcon, size: 50, color: Colors.white70),
          Column(
            spacing: 0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Transform.translate(
                offset: const Offset(0, 4),
                child: Text(
                  '${temperature.toString()}°',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -2),
                child: Text(
                  condition,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                ),
              ),
            ],
          ),
        ],
      );
  }
}
