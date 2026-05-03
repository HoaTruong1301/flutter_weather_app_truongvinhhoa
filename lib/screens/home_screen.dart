import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'search_screen.dart';
import 'forecast_screen.dart';
import 'settings_screen.dart';
import '../providers/weather_provider.dart';
import '../providers/location_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/hourly_forecast_list.dart';
import '../widgets/daily_forecast_card.dart';
import '../widgets/weather_detail_item.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_shimmer.dart';
import '../utils/constants.dart';
import '../utils/weather_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadWeather();
    });
  }

  Future<void> _loadWeather() async {
    final settingsProvider = context.read<SettingsProvider>();
    context.read<WeatherProvider>().fetchWeatherByLocation(
      units: settingsProvider.isMetric ? 'metric' : 'imperial',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<WeatherProvider, SettingsProvider>(
      builder: (context, weatherProvider, settingsProvider, child) {
        final weather = weatherProvider.weather;
        final forecast = weatherProvider.forecast;
        final isLoading = weatherProvider.state == WeatherState.loading;
        final isMetric = settingsProvider.isMetric;

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: const Text(
              "Thời tiết hiện tại",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.my_location, color: Colors.white),
                onPressed: _loadWeather,
              ),
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SearchScreen()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsScreen()),
                  );
                },
              ),
            ],
          ),
          body: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
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
              child: RefreshIndicator(
                onRefresh: _loadWeather,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(AppConstants.screenPadding),
                  child: Column(
                    children: [
                      if (isLoading)
                        const _LoadingView()
                      else if (weatherProvider.error.isNotEmpty)
                        AppErrorWidget(
                          errorMessage: weatherProvider.error,
                          onRetry: _loadWeather,
                        )
                      else if (weather != null) ...[
                        CurrentWeatherCard(weather: weather, isMetric: isMetric),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            WeatherDetailItem(
                              label: "Độ ẩm",
                              value: "${weather.humidity}%",
                              icon: Icons.water_drop,
                            ),
                            WeatherDetailItem(
                              label: "Cảm giác",
                              value: "${weather.feelsLike.round()}°${isMetric ? 'C' : 'F'}",
                              icon: Icons.thermostat,
                            ),
                            WeatherDetailItem(
                              label: "Gió",
                              value: "${weather.windSpeed} ${isMetric ? 'm/s' : 'mph'}",
                              icon: Icons.air,
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        if (forecast != null) ...[
                          HourlyForecastList(
                            hourlyForecast: forecast.hourly,
                            isMetric: isMetric,
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Dự báo 5 ngày",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const ForecastScreen()),
                                  );
                                },
                                child: const Text(
                                  "Xem tất cả",
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ...forecast.daily.map((day) => DailyForecastCard(
                            forecast: day,
                            isMetric: isMetric,
                          )),
                        ],
                      ] else
                        const Center(
                          child: Text(
                            "Không có dữ liệu. Vui lòng thử lại.",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const LoadingShimmer(width: 200, height: 30),
        const SizedBox(height: 10),
        const LoadingShimmer(width: 150, height: 20),
        const SizedBox(height: 20),
        const Center(child: LoadingShimmer(width: 120, height: 120, borderRadius: 60)),
        const SizedBox(height: 20),
        const LoadingShimmer(width: 100, height: 60),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(3, (index) => const LoadingShimmer(width: 90, height: 100, borderRadius: 20)),
        ),
      ],
    );
  }
}
