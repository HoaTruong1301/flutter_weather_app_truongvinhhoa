import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_weather_app_truongvinhhoa/main.dart';
import 'package:flutter_weather_app_truongvinhhoa/providers/weather_provider.dart';

void main() {
  testWidgets('Weather App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => WeatherProvider(),
        child: const MyApp(),
      ),
    );

    expect(find.text('Weather App'), findsOneWidget);
    expect(find.text('Nhập thành phố'), findsOneWidget);
  });
}
