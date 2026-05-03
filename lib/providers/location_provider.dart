import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';

class LocationProvider extends ChangeNotifier {
  final LocationService _locationService;
  
  LocationProvider(this._locationService);

  Position? _currentPosition;
  String _error = '';
  bool _isLoading = false;

  Position? get currentPosition => _currentPosition;
  String get error => _error;
  bool get isLoading => _isLoading;

  Future<void> determinePosition() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _currentPosition = await _locationService.getCurrentLocation();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
