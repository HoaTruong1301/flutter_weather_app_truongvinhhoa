import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'providers/weather_provider.dart';
import 'providers/location_provider.dart';
import 'providers/settings_provider.dart';
import 'services/weather_service.dart';
import 'services/location_service.dart';
import 'services/storage_service.dart';
import 'config/api_config.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  
  final weatherService = WeatherService(apiKey: ApiConfig.apiKey);
  final locationService = LocationService();
  final storageService = StorageService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WeatherProvider(
            weatherService,
            locationService,
            storageService,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => LocationProvider(locationService),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}
