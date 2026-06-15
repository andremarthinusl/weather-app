import 'dart:async';

import 'package:open_meteo_api/open_meteo_api.dart' hide Weather;
import 'package:weather_repository/weather_repository.dart';

class WeatherRepository {
  WeatherRepository({OpenMeteoApiClient? weatherApiClient})
    : _weatherApiClient = weatherApiClient ?? OpenMeteoApiClient();

  final OpenMeteoApiClient _weatherApiClient;

  Future<Weather> getWeather(String city) async {
    final location = await _weatherApiClient.locationSearch(city);
    final results = await Future.wait([
      _weatherApiClient.getWeather(
        latitude: location.latitude,
        longitude: location.longitude,
      ),
      _weatherApiClient.getAirQuality(
        latitude: location.latitude,
        longitude: location.longitude,
      ),
    ]);

    final weatherData = results[0] as WeatherData;
    final aqiData = results[1] as AirQualityResponse;

    final hourly = <HourlyWeather>[];
    for (var i = 0; i < weatherData.hourlyForecast.time.length; i++) {
      if (i > 24) break; // Only take next 24 hours
      hourly.add(HourlyWeather(
        time: DateTime.parse(weatherData.hourlyForecast.time[i]),
        temperature: weatherData.hourlyForecast.temperature2m[i],
        condition: weatherData.hourlyForecast.weatherCode[i].toInt().toCondition,
      ));
    }

    final daily = <DailyWeather>[];
    for (var i = 0; i < weatherData.dailyForecast.time.length; i++) {
      daily.add(DailyWeather(
        time: DateTime.parse(weatherData.dailyForecast.time[i]),
        temperatureMax: weatherData.dailyForecast.temperature2mMax[i],
        temperatureMin: weatherData.dailyForecast.temperature2mMin[i],
        condition: weatherData.dailyForecast.weatherCode[i].toInt().toCondition,
      ));
    }

    final currentIndex = DateTime.now().hour;
    final currentHumidity = weatherData.hourlyForecast.relativeHumidity2m.length > currentIndex
        ? weatherData.hourlyForecast.relativeHumidity2m[currentIndex]
        : 0.0;
    final currentFeelsLike = weatherData.hourlyForecast.apparentTemperature.length > currentIndex
        ? weatherData.hourlyForecast.apparentTemperature[currentIndex]
        : weatherData.currentWeather.temperature;
    final currentUvIndex = weatherData.hourlyForecast.uvIndex.length > currentIndex
        ? weatherData.hourlyForecast.uvIndex[currentIndex]
        : 0.0;

    return Weather(
      temperature: weatherData.currentWeather.temperature,
      location: location.name,
      condition: weatherData.currentWeather.weatherCode.toInt().toCondition,
      isDay: weatherData.currentWeather.isDay == 1,
      windSpeed: weatherData.currentWeather.windSpeed,
      windDirection: weatherData.currentWeather.windDirection,
      humidity: currentHumidity,
      feelsLike: currentFeelsLike,
      uvIndex: currentUvIndex,
      aqi: aqiData.current.usAqi,
      pm25: aqiData.current.pm25,
      hourlyForecast: hourly,
      dailyForecast: daily,
    );
  }

  Future<List<String>> searchLocations(String query) async {
    final locations = await _weatherApiClient.searchLocations(query);
    return locations.map((loc) => loc.name).toList();
  }

  void dispose() => _weatherApiClient.close();
}

extension on int {
  WeatherCondition get toCondition {
    switch (this) {
      case 0:
        return WeatherCondition.clear;
      case 1:
      case 2:
      case 3:
      case 45:
      case 48:
        return WeatherCondition.cloudy;
      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
      case 61:
      case 63:
      case 65:
      case 66:
      case 67:
      case 80:
      case 81:
      case 82:
      case 95:
      case 96:
      case 99:
        return WeatherCondition.rainy;
      case 71:
      case 73:
      case 75:
      case 77:
      case 85:
      case 86:
        return WeatherCondition.snowy;
      default:
        return WeatherCondition.unknown;
    }
  }
}
