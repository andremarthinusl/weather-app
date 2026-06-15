import 'package:json_annotation/json_annotation.dart';

part 'weather.g.dart';

@JsonSerializable()
class Weather {
  const Weather({
    required this.temperature,
    required this.weatherCode,
    this.windSpeed = 0,
    this.windDirection = 0,
    this.isDay = 1,
  });

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);

  final double temperature;
  @JsonKey(name: 'weathercode')
  final double weatherCode;
  @JsonKey(name: 'windspeed')
  final double windSpeed;
  @JsonKey(name: 'winddirection')
  final double windDirection;
  @JsonKey(name: 'is_day')
  final int isDay;
}

@JsonSerializable()
class HourlyForecast {
  const HourlyForecast({
    required this.time,
    required this.temperature2m,
    required this.weatherCode,
    this.relativeHumidity2m = const [],
    this.apparentTemperature = const [],
    this.uvIndex = const [],
  });

  factory HourlyForecast.fromJson(Map<String, dynamic> json) =>
      _$HourlyForecastFromJson(json);

  final List<String> time;
  @JsonKey(name: 'temperature_2m')
  final List<double> temperature2m;
  @JsonKey(name: 'weathercode')
  final List<double> weatherCode;
  @JsonKey(name: 'relative_humidity_2m')
  final List<double> relativeHumidity2m;
  @JsonKey(name: 'apparent_temperature')
  final List<double> apparentTemperature;
  @JsonKey(name: 'uv_index')
  final List<double> uvIndex;
}

@JsonSerializable()
class DailyForecast {
  const DailyForecast({
    required this.time,
    required this.weatherCode,
    required this.temperature2mMax,
    required this.temperature2mMin,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) =>
      _$DailyForecastFromJson(json);

  final List<String> time;
  @JsonKey(name: 'weathercode')
  final List<double> weatherCode;
  @JsonKey(name: 'temperature_2m_max')
  final List<double> temperature2mMax;
  @JsonKey(name: 'temperature_2m_min')
  final List<double> temperature2mMin;
}

class WeatherData {
  const WeatherData({
    required this.currentWeather,
    required this.hourlyForecast,
    required this.dailyForecast,
  });

  final Weather currentWeather;
  final HourlyForecast hourlyForecast;
  final DailyForecast dailyForecast;
}
