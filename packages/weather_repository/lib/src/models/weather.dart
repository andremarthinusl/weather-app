import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'weather.g.dart';

enum WeatherCondition {
  clear,
  rainy,
  cloudy,
  snowy,
  unknown,
}

@JsonSerializable(explicitToJson: true)
class Weather extends Equatable {
  const Weather({
    required this.location,
    required this.temperature,
    required this.condition,
    required this.isDay,
    required this.windSpeed,
    required this.windDirection,
    required this.humidity,
    required this.feelsLike,
    required this.uvIndex,
    required this.aqi,
    required this.pm25,
    required this.hourlyForecast,
    required this.dailyForecast,
  });

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherToJson(this);

  final String location;
  final double temperature;
  final WeatherCondition condition;
  final bool isDay;
  final double windSpeed;
  final double windDirection;
  final double humidity;
  final double feelsLike;
  final double uvIndex;
  final double aqi;
  final double pm25;
  final List<HourlyWeather> hourlyForecast;
  final List<DailyWeather> dailyForecast;

  @override
  List<Object> get props => [
        location,
        temperature,
        condition,
        isDay,
        windSpeed,
        windDirection,
        humidity,
        feelsLike,
        uvIndex,
        aqi,
        pm25,
        hourlyForecast,
        dailyForecast,
      ];
}

@JsonSerializable()
class HourlyWeather extends Equatable {
  const HourlyWeather({
    required this.time,
    required this.temperature,
    required this.condition,
  });

  factory HourlyWeather.fromJson(Map<String, dynamic> json) =>
      _$HourlyWeatherFromJson(json);

  Map<String, dynamic> toJson() => _$HourlyWeatherToJson(this);

  final DateTime time;
  final double temperature;
  final WeatherCondition condition;

  @override
  List<Object> get props => [time, temperature, condition];
}

@JsonSerializable()
class DailyWeather extends Equatable {
  const DailyWeather({
    required this.time,
    required this.temperatureMax,
    required this.temperatureMin,
    required this.condition,
  });

  factory DailyWeather.fromJson(Map<String, dynamic> json) =>
      _$DailyWeatherFromJson(json);

  Map<String, dynamic> toJson() => _$DailyWeatherToJson(this);

  final DateTime time;
  final double temperatureMax;
  final double temperatureMin;
  final WeatherCondition condition;

  @override
  List<Object> get props => [time, temperatureMax, temperatureMin, condition];
}
