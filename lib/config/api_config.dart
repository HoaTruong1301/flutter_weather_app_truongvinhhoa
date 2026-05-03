import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  static String get apiKey => dotenv.env['OPENWEATHER_API_KEY'] ?? '';

  // Endpoints
  static const String currentWeather = '/weather';
  static const String forecast = '/forecast';
  static const String oneCall = '/onecall';

  // Build URL helper from Step 3 specs
  static String buildUrl(String endpoint, Map<String, dynamic> params, {String units = 'metric'}) {
    final uri = Uri.parse('$baseUrl$endpoint');
    params['appid'] = apiKey;
    params['units'] = units;
    params['lang'] = 'vi'; // Thêm hỗ trợ tiếng Việt từ API
    
    // Convert all values to strings to satisfy Uri requirements
    final queryParams = params.map((key, value) => MapEntry(key, value.toString()));
    return uri.replace(queryParameters: queryParams).toString();
  }
}
