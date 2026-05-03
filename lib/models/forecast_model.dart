class ForecastModel {
  final DateTime dateTime;
  final double temperature;
  final String description;
  final String icon;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final double windSpeed;
  final double? pop; // Probability of precipitation
  
  ForecastModel({
    required this.dateTime,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.windSpeed,
    this.pop,
  });
  
  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    return ForecastModel(
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      tempMin: json['main']['temp_min'].toDouble(),
      tempMax: json['main']['temp_max'].toDouble(),
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      pop: json['pop']?.toDouble(),
    );
  }
}

class WeatherForecast {
  final List<ForecastModel> hourly;
  final List<ForecastModel> daily;

  WeatherForecast({required this.hourly, required this.daily});

  factory WeatherForecast.fromList(List<ForecastModel> list) {
    // Splitting logic: next 12 items for hourly, every 8th item for daily
    List<ForecastModel> dailyList = [];
    for (int i = 0; i < list.length; i += 8) {
      dailyList.add(list[i]);
    }

    return WeatherForecast(
      hourly: list.take(12).toList(),
      daily: dailyList,
    );
  }

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    final list = (json['list'] as List? ?? [])
        .map((item) => ForecastModel.fromJson(item))
        .toList();
    return WeatherForecast.fromList(list);
  }
}
