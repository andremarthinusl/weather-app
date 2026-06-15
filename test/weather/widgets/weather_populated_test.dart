// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_weather/weather/weather.dart';

void main() {
  group('WeatherPopulated', () {
    final weather = Weather(
      condition: WeatherCondition.clear,
      temperature: const Temperature(value: 42),
      location: 'Chicago',
      lastUpdated: DateTime(2020),
      isDay: true,
      windSpeed: 0,
      windDirection: 0,
      humidity: 0,
      feelsLike: 0,
      uvIndex: 0,
      aqi: 0,
      pm25: 0,
      hourlyForecast: const [],
      dailyForecast: const [],
    );

    testWidgets('renders correct emoji (clear)', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherPopulated(
              weather: weather,
              units: TemperatureUnits.fahrenheit,
              onRefresh: () async {},
            ),
          ),
        ),
      );
      expect(find.text('☀️'), findsOneWidget);
    });

    testWidgets('renders correct emoji (rainy)', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherPopulated(
              weather: weather.copyWith(condition: WeatherCondition.rainy),
              units: TemperatureUnits.fahrenheit,
              onRefresh: () async {},
            ),
          ),
        ),
      );
      expect(find.text('🌧️'), findsOneWidget);
    });

    testWidgets('renders correct emoji (cloudy)', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherPopulated(
              weather: weather.copyWith(condition: WeatherCondition.cloudy),
              units: TemperatureUnits.fahrenheit,
              onRefresh: () async {},
            ),
          ),
        ),
      );
      expect(find.text('☁️'), findsOneWidget);
    });

    testWidgets('renders correct emoji (snowy)', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherPopulated(
              weather: weather.copyWith(condition: WeatherCondition.snowy),
              units: TemperatureUnits.fahrenheit,
              onRefresh: () async {},
            ),
          ),
        ),
      );
      expect(find.text('🌨️'), findsOneWidget);
    });

    testWidgets('renders correct emoji (unknown)', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherPopulated(
              weather: weather.copyWith(condition: WeatherCondition.unknown),
              units: TemperatureUnits.fahrenheit,
              onRefresh: () async {},
            ),
          ),
        ),
      );
      expect(find.text('❓'), findsOneWidget);
    });
  });
}
