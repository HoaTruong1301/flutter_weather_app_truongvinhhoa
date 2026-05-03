import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_weather_app_truongvinhhoa/models/weather_model.dart';
import 'package:flutter_weather_app_truongvinhhoa/services/weather_service.dart';

void main() {
  group('WeatherService Tests', () {
    test('Parse weather JSON correctly', () {
      final json = {
        'name': 'Ho Chi Minh City',
        'sys': {'country': 'VN'},
        'main': {
          'temp': 25.0,
          'feels_like': 27.0,
          'humidity': 80,
          'pressure': 1010,
        },
        'wind': {'speed': 5.5},
        'weather': [
          {
            'description': 'clear sky',
            'icon': '01d',
            'main': 'Clear',
          }
        ],
        'dt': 1633072800,
      };

      final weather = WeatherModel.fromJson(json);

      expect(weather.cityName, 'Ho Chi Minh City');
      expect(weather.temperature, 25.0);
      expect(weather.country, 'VN');
      expect(weather.description, 'clear sky');
    });

    test('Handle API error gracefully', () async {
      final weatherService = WeatherService(apiKey: 'INVALID_KEY');
      
      expect(
        () => weatherService.getCurrentWeatherByCity('InvalidCityName123'),
        throwsException,
      );
    });
  });
}
