import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

const apiKey = '457264298ff2cbd649094185342102dc';

void main() {
  runApp(NetworkingApp());
}

class NetworkingApp extends StatelessWidget {
  const NetworkingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.low,
    distanceFilter: 100,
  );

  void getLocation() async {
    //Ask for permission
    LocationPermission permission = await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );
    print(position);
  }

  // Get HTTP Data
  void getData() async {
    http.Response response = await http.get(
      Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?lat=44.34&lon=10.99&appid=457264298ff2cbd649094185342102dc",
      ),
    );
    print(response.statusCode);
    String WeatherData = response.body;
    print(WeatherData);

    var longitude = jsonDecode(WeatherData)['coord']['lon'];
    print(longitude);

    var weather = jsonDecode(WeatherData)['weather'][0]['description'];
    print(weather);

    var main_description = jsonDecode(WeatherData)['weather'][0]['main'];
    print(main_description);

    var temp = jsonDecode(WeatherData)['main']['temp'];
    print(temp);

    var humidity = jsonDecode(WeatherData)['main']['humidity'];
    print(humidity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('Netowrking App'))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud, size: 80, color: Colors.blue),
            SizedBox(height: 30),
            Text(
              'welcome to the Networking App',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                print('Location button pressed');
                getData();
                //getLocation();
              },
              child: Text('Check Location'),
            ),
          ],
        ),
      ),
    );
  }
}
