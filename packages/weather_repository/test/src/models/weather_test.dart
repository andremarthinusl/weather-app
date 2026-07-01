// ignore_for_file: prefer_const_constructors

import 'package:test/test.dart';
import 'package:weather_repository/weather_repository.dart';

void main() {
  group('Weather', () {
    test('can be (de)serialized', () {
      final weather = Weather(
        condition: WeatherCondition.cloudy,
        temperature: 10.2,
        location: 'Chicago',
        isDay: true,
        windSpeed: 10.0,
        windDirection: 180.0,
        humidity: 50.0,
        feelsLike: 10.2,
        uvIndex: 5.0,
        aqi: 20.0,
        pm25: 10.0,
        hourlyForecast: const [],
        dailyForecast: const [],
      );
      expect(Weather.fromJson(weather.toJson()), equals(weather));
    });
  });
}
