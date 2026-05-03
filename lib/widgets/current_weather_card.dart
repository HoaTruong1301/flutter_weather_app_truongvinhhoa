import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../utils/constants.dart';
import '../utils/weather_icons.dart';
import '../utils/date_formatter.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CurrentWeatherCard extends StatelessWidget {
  final WeatherModel weather;
  final bool isMetric;

  const CurrentWeatherCard({
    super.key, 
    required this.weather,
    this.isMetric = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          weather.cityName,
          style: const TextStyle(
            fontSize: 32,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          DateFormatter.formatFullDate(weather.dateTime),
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
        const SizedBox(height: 10),
        CachedNetworkImage(
          imageUrl: WeatherIcons.getIconUrl(weather.icon),
          height: 160,
          placeholder: (context, url) =>
              const CircularProgressIndicator(color: Colors.white24),
          errorWidget: (context, url, error) => Icon(
            WeatherIcons.getWeatherIcon(weather.mainCondition, weather.icon),
            size: 100,
            color: Colors.white,
          ),
        ),
        Text(
          "${weather.temperature.round()}°${isMetric ? 'C' : 'F'}",
          style: const TextStyle(
            fontSize: 80,
            color: Colors.white,
            fontWeight: FontWeight.w200,
          ),
        ),
        Text(
          weather.description.toUpperCase(),
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}
