import 'package:flutter/material.dart';

class WeatherIcons {
  static IconData getWeatherIcon(String? condition, String? iconCode) {
    if (iconCode != null && iconCode.endsWith('n')) return Icons.nights_stay;
    if (condition == null) return Icons.help_outline;
    
    switch (condition.toLowerCase()) {
      case 'clouds':
        return Icons.cloud;
      case 'rain':
      case 'drizzle':
        return Icons.umbrella;
      case 'snow':
        return Icons.ac_unit;
      case 'clear':
        return Icons.wb_sunny;
      case 'thunderstorm':
        return Icons.thunderstorm;
      default:
        return Icons.wb_cloudy;
    }
  }

  static String getIconUrl(String iconCode) {
    return "https://openweathermap.org/img/wn/$iconCode@4x.png";
  }
}
