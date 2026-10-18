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
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.low,
      distanceFilter: 100,
    );

    await Geolocator.requestPermission();

    Position? position = await Geolocator.getLastKnownPosition();
    position ??= await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );
    print(position);
    return position;
  }

  void loadWeather() async {
    Position position = await getLocation();

    http.Response response = await http.get(
      Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey&units=imperial',
      ),
    );
    print(response.statusCode);

    String weatherData = response.body;
    var decodedData = jsonDecode(weatherData);

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
      appBar: AppBar(title: Center(child: Text('Current Weather'))),
      body: isLoading
          ? SpinKitDualRing(color: Colors.blue, size: 60)
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wb_cloudy, size: 80, color: Colors.lightBlue),
                  SizedBox(height: 20),
                  Text(cityName, style: TextStyle(fontSize: 20)),
                  SizedBox(height: 20),
                  Text(
                    '${temperature.round()}°F',
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                  Text(description, style: TextStyle(fontSize: 20)),
                  SizedBox(height: 20),
                  Text('Humidity: $humidity%'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      print('back button pressed');
                      Navigator.pop(context);
                    },
                    child: Text('Back to Home'),
                  ),
                ],
              ),
            ),
    );
  }
}
