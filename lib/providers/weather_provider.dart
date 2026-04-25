import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherProvider extends ChangeNotifier {
  WeatherModel? weather;
  bool isLoading = false;

  final WeatherService service = WeatherService();

  Future<void> getWeather(String city) async {
    isLoading = true;
    notifyListeners();

    try {
      weather = await service.fetchWeather(city);
    } catch (e) {
      print(e);
    }

    isLoading = false;
    notifyListeners();
  }
}