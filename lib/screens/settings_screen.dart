import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../providers/weather_provider.dart';
import '../utils/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.nightBackground,
      appBar: AppBar(
        title: const Text("Cài đặt", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Consumer2<SettingsProvider, WeatherProvider>(
        builder: (context, settings, weatherProvider, child) {
          return ListView(
            padding: const EdgeInsets.all(AppConstants.screenPadding),
            children: [
              _buildSettingItem(
                title: "Đơn vị nhiệt độ",
                subtitle: settings.isMetric ? "Celsius (°C)" : "Fahrenheit (°F)",
                icon: Icons.thermostat,
                onTap: () async {
                  await settings.toggleUnits();
                  weatherProvider.refreshWeather(
                    units: settings.isMetric ? 'metric' : 'imperial',
                  );
                },
              ),
              _buildSettingItem(
                title: "Ngôn ngữ",
                subtitle: "Tiếng Việt",
                icon: Icons.language,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Tính năng đang được phát triển")),
                  );
                },
              ),
              _buildSettingItem(
                title: "Về ứng dụng",
                subtitle: "Phiên bản 1.0.0",
                icon: Icons.info_outline,
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: "Weather App",
                    applicationVersion: "1.0.0",
                    applicationIcon: const Icon(Icons.wb_sunny, size: 50, color: Colors.orange),
                    children: [
                      const Text("Ứng dụng thời tiết được xây dựng bằng Flutter."),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSettingItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.white.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70)),
        trailing: const Icon(Icons.chevron_right, color: Colors.white70),
        onTap: onTap,
      ),
    );
  }
}
