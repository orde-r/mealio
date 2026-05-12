import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mealio/Pages/welcome_page.dart';

Future<void> main() async {
  await dotenv.load();
  _requestLocationPermission();
  runApp(const MyApp());
}

void _requestLocationPermission() {
  Geolocator.checkPermission().then((permission) {
    if (permission == LocationPermission.denied) {
      Geolocator.requestPermission();
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WelcomePage(),
    );
  }
}
