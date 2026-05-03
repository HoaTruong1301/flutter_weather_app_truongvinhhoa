import 'package:flutter/material.dart';
import 'constants.dart';

class WeatherTheme {
  static Color getPrimaryColor(String? condition, String? iconCode) {
    if (iconCode != null && iconCode.endsWith('n')) return AppConstants.nightPrimary;
    if (condition == null) return AppConstants.defaultPrimary;
    switch (condition.toLowerCase()) {
      case 'clear': return AppConstants.sunnyPrimary;
      case 'rain':
      case 'drizzle':
      case 'thunderstorm': return AppConstants.rainyPrimary;
      case 'clouds': return AppConstants.cloudyPrimary;
      default: return AppConstants.defaultPrimary;
    }
  }

  static Color getBackgroundColor(String? condition, String? iconCode) {
    if (iconCode != null && iconCode.endsWith('n')) return AppConstants.nightBackground;
    if (condition == null) return AppConstants.defaultBackground;
    switch (condition.toLowerCase()) {
      case 'clear': return AppConstants.sunnyBackground;
      case 'rain':
      case 'drizzle':
      case 'thunderstorm': return AppConstants.rainyBackground;
      case 'clouds': return AppConstants.cloudyBackground;
      default: return AppConstants.defaultBackground;
    }
  }
}
