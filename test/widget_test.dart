import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_weather_app_truongvinhhoa/main.dart';
import 'package:flutter_weather_app_truongvinhhoa/providers/weather_provider.dart';
import 'package:flutter_weather_app_truongvinhhoa/providers/location_provider.dart';
import 'package:flutter_weather_app_truongvinhhoa/providers/settings_provider.dart';
import 'package:flutter_weather_app_truongvinhhoa/services/weather_service.dart';
import 'package:flutter_weather_app_truongvinhhoa/services/location_service.dart';
import 'package:flutter_weather_app_truongvinhhoa/services/storage_service.dart';

void main() {
  testWidgets('Weather App smoke test', (WidgetTester tester) async {
    // Create dummy services for testing
    final weatherService = WeatherService(apiKey: 'test_key');
    final locationService = LocationService();
    final storageService = StorageService();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => WeatherProvider(
              weatherService,
              locationService,
              storageService,
            ),
          ),
          ChangeNotifierProvider(
            create: (_) => LocationProvider(locationService),
          ),
          ChangeNotifierProvider(
            create: (_) => SettingsProvider(),
          ),
        ],
        child: const MyApp(),
      ),
    );

    // Verify that the Home Screen loads
    expect(find.text('Weather Now'), findsOneWidget);

    // Verify that the search icon is present
    expect(find.byIcon(Icons.search), findsOneWidget);
    
    // Tap the search icon to navigate
    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    // Verify that we are on the Search Screen
    expect(find.textContaining('Nhập tên thành phố'), findsOneWidget);
  });
}
