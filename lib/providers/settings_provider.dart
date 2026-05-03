import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  bool _isMetric = true;

  bool get isMetric => _isMetric;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isMetric = prefs.getBool('isMetric') ?? true;
    notifyListeners();
  }

  Future<void> toggleUnits() async {
    _isMetric = !_isMetric;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isMetric', _isMetric);
    notifyListeners();
  }
}
