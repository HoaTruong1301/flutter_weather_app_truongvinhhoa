import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/daily_forecast_card.dart';
import '../utils/constants.dart';
import '../utils/weather_theme.dart';

class ForecastScreen extends StatelessWidget {
  const ForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherProvider = context.watch<WeatherProvider>();
    final settingsProvider = context.watch<SettingsProvider>();
    final forecast = weatherProvider.forecast;
    final weather = weatherProvider.weather;
    final isMetric = settingsProvider.isMetric;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Dự báo 5 ngày", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              WeatherTheme.getPrimaryColor(weather?.mainCondition, weather?.icon),
              WeatherTheme.getBackgroundColor(weather?.mainCondition, weather?.icon),
            ],
          ),
        ),
        child: SafeArea(
          child: forecast == null
              ? const Center(child: Text("Không có dữ liệu dự báo", style: TextStyle(color: Colors.white70)))
              : ListView.builder(
                  padding: const EdgeInsets.all(AppConstants.screenPadding),
                  itemCount: forecast.daily.length,
                  itemBuilder: (context, index) {
                    return DailyForecastCard(
                      forecast: forecast.daily[index],
                      isMetric: isMetric,
                    );
                  },
                ),
        ),
      ),
    );
  }
}
