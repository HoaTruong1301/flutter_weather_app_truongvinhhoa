import 'package:flutter/material.dart';
import '../models/forecast_model.dart';
import '../utils/date_formatter.dart';
import '../utils/weather_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DailyForecastCard extends StatelessWidget {
  final ForecastModel forecast;
  final bool isMetric;

  const DailyForecastCard({
    super.key, 
    required this.forecast,
    this.isMetric = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              DateFormatter.formatDay(forecast.dateTime),
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          Expanded(
            child: CachedNetworkImage(
              imageUrl: WeatherIcons.getIconUrl(forecast.icon),
              height: 40,
              width: 40,
              errorWidget: (context, url, error) => Icon(
                WeatherIcons.getWeatherIcon(forecast.description, forecast.icon),
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          Expanded(
            child: Text(
              "${forecast.temperature.round()}°${isMetric ? 'C' : 'F'}",
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
