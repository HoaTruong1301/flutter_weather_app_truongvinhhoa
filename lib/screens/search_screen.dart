import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../providers/settings_provider.dart';
import '../utils/constants.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearch() {
    if (_controller.text.trim().isNotEmpty) {
      final units = context.read<SettingsProvider>().isMetric ? 'metric' : 'imperial';
      context.read<WeatherProvider>().fetchWeatherByCity(_controller.text.trim(), units: units);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.nightBackground,
      appBar: AppBar(
        title: const Text("Tìm kiếm thành phố", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.screenPadding),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Nhập tên thành phố...",
                hintStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: Colors.white70),
                  onPressed: () => _controller.clear(),
                ),
              ),
              onSubmitted: (_) => _onSearch(),
            ),
            const SizedBox(height: 20),
            const Text(
              "Gợi ý: Hà Nội, TP. Hồ Chí Minh, Đà Nẵng, London, Tokyo, New York...",
              style: TextStyle(color: Colors.white60, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
