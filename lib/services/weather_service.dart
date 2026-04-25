import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  final String apiKey = "83aecd8c64bc30f3c441c09b7a4e3205";

  Future<WeatherModel> fetchWeather(String city) async {
    final url =
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Lỗi khi gọi API");
    }
  }
}