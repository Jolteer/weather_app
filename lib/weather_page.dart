import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

const apiKey = '457264298ff2cbd649094185342102dc';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  bool isLoading = true;
  String cityName = '';
  double temperature = 0;
  String description = '';
  int humidity = 0;

  @override
  void initState() {
    super.initState();
    loadWeather();
  }

  Future<Position> getLocation() async {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.low,
      distanceFilter: 100,
    );

    await Geolocator.requestPermission();

    Position? position = await Geolocator.getLastKnownPosition();
    position ??= await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );

    return position;
  }

  Future<void> loadWeather() async {
    final position = await getLocation();

    final response = await http.get(
      Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather'
        '?lat=${position.latitude}'
        '&lon=${position.longitude}'
        '&appid=$apiKey'
        '&units=imperial',
      ),
    );

    final decodedData = jsonDecode(response.body);

    setState(() {
      cityName = decodedData['name'];
      temperature = decodedData['main']['temp'].toDouble();
      description = decodedData['weather'][0]['description'];
      humidity = decodedData['main']['humidity'];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('Current Weather'))),
      body: isLoading
          ? const SpinKitDualRing(color: Colors.blue, size: 60)
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.wb_cloudy,
                    size: 80,
                    color: Colors.lightBlue,
                  ),
                  const SizedBox(height: 20),
                  Text(cityName, style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 20),
                  Text(
                    '${temperature.round()}°F',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(description, style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 20),
                  Text('Humidity: $humidity%'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Back to Home'),
                  ),
                ],
              ),
            ),
    );
  }
}
