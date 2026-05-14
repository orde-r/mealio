import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mealio/Pages/welcome_page.dart';
import 'package:mealio/theme/mealio_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      theme: MealioTheme.light(),
      home: const WelcomePage(),
    );
  }
}
