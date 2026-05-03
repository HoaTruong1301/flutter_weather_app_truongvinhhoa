import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';
import '../services/connectivity_service.dart';
import '../config/api_config.dart';

enum WeatherState { initial, loading, loaded, error }

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService;
  final LocationService _locationService;
  final StorageService _storageService;
  final ConnectivityService _connectivityService = ConnectivityService();
  
  WeatherModel? _currentWeather;
  WeatherForecast? _forecast;
  WeatherState _state = WeatherState.initial;
  String _errorMessage = '';
  
  String _lastCity = '';
  double? _lastLat;
  double? _lastLon;

  WeatherProvider(
    this._weatherService,
    this._locationService,
    this._storageService,
  );

  // Getters
  WeatherModel? get currentWeather => _currentWeather;
  WeatherModel? get weather => _currentWeather; // Alias for backward compatibility
  WeatherForecast? get forecast => _forecast;
  WeatherState get state => _state;
  bool get isLoading => _state == WeatherState.loading;
  String get errorMessage => _errorMessage;
  String get error => _errorMessage; // Alias for backward compatibility

  // Fetch weather by city
  Future<void> fetchWeatherByCity(String cityName, {String units = 'metric'}) async {
    _lastCity = cityName;
    _lastLat = null;
    _lastLon = null;
    _state = WeatherState.loading;
    _errorMessage = '';
    notifyListeners();
    
    try {
      _currentWeather = await _weatherService.getCurrentWeatherByCity(cityName, units: units);
      final forecastList = await _weatherService.getForecast(cityName, units: units);
      _forecast = WeatherForecast.fromList(forecastList);
      
      if (_currentWeather != null) {
        await _storageService.saveWeatherData(_currentWeather!);
      }
      
      _state = WeatherState.loaded;
      _errorMessage = '';
    } catch (e) {
      _state = WeatherState.error;
      _errorMessage = e.toString();
      
      // Try to load cached data if no connection
      if (!await _connectivityService.isConnected()) {
        await loadCachedWeather();
        if (_currentWeather != null) {
          _state = WeatherState.loaded;
          _errorMessage = "Không có kết nối mạng. Đang hiển thị dữ liệu cũ.";
        }
      }
    }
    notifyListeners();
  }
  
  // Fetch weather by current location
  Future<void> fetchWeatherByLocation({String units = 'metric'}) async {
    _state = WeatherState.loading;
    _errorMessage = '';
    notifyListeners();
    
    try {
      final position = await _locationService.getCurrentLocation();
      _lastLat = position.latitude;
      _lastLon = position.longitude;
      _lastCity = '';

      _currentWeather = await _weatherService.getCurrentWeatherByCoordinates(
        position.latitude,
        position.longitude,
        units: units,
      );
      
      final forecastList = await _weatherService.getForecastByCoordinates(
        position.latitude,
        position.longitude,
        units: units,
      );
      _forecast = WeatherForecast.fromList(forecastList);
      
      if (_currentWeather != null) {
        await _storageService.saveWeatherData(_currentWeather!);
      }
      
      _state = WeatherState.loaded;
      _errorMessage = '';
    } catch (e) {
      _state = WeatherState.error;
      _errorMessage = e.toString();
      
      // Try to load cached data
      await loadCachedWeather();
      if (_currentWeather != null) {
        _state = WeatherState.loaded;
        if (!await _connectivityService.isConnected()) {
           _errorMessage = "Không có kết nối mạng. Đang hiển thị dữ liệu cũ.";
        }
      }
    }
    notifyListeners();
  }
  
  // Load cached weather
  Future<void> loadCachedWeather() async {
    final cachedWeather = await _storageService.getCachedWeather();
    if (cachedWeather != null) {
      _currentWeather = cachedWeather;
      _state = WeatherState.loaded;
      notifyListeners();
    }
  }
  
  // Refresh weather data
  Future<void> refreshWeather({required String units}) async {
    if (_lastCity.isNotEmpty) {
      await fetchWeatherByCity(_lastCity, units: units);
    } else {
      await fetchWeatherByLocation(units: units);
    }
  }
}
