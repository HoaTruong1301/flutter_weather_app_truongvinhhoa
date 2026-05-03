class HourlyWeatherModel {
  final DateTime time;
  final double temp;
  final String icon;
  final String condition;

  HourlyWeatherModel({
    required this.time,
    required this.temp,
    required this.icon,
    required this.condition,
  });

  factory HourlyWeatherModel.fromJson(Map<String, dynamic> json) {
    return HourlyWeatherModel(
      time: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temp: (json['main']['temp'] as num).toDouble(),
      icon: json['weather'][0]['icon'],
      condition: json['weather'][0]['main'],
    );
  }
}
