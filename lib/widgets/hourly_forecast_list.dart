import 'package:flutter/material.dart';
import '../models/forecast_model.dart';
import '../utils/date_formatter.dart';
import '../utils/weather_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HourlyForecastList extends StatelessWidget {
  final List<ForecastModel> hourlyForecast;
  final bool isMetric;

  const HourlyForecastList({
    super.key, 
    required this.hourlyForecast,
    this.isMetric = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Dự báo theo giờ",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: hourlyForecast.length > 24 ? 24 : hourlyForecast.length,
            itemBuilder: (context, index) {
              final hourly = hourlyForecast[index];
              return Container(
                width: 70,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormatter.formatTime(hourly.dateTime),
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    CachedNetworkImage(
                      imageUrl: WeatherIcons.getIconUrl(hourly.icon),
                      height: 40,
                      width: 40,
                      errorWidget: (context, url, error) => Icon(
                        WeatherIcons.getWeatherIcon(hourly.description, hourly.icon),
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    Text(
                      "${hourly.temperature.round()}°${isMetric ? 'C' : 'F'}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
