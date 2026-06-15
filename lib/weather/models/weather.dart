import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:weather_repository/weather_repository.dart' hide Weather;
import 'package:weather_repository/weather_repository.dart'
    as weather_repository;

part 'weather.g.dart';

enum TemperatureUnits { fahrenheit, celsius }

extension TemperatureUnitsX on TemperatureUnits {
  bool get isFahrenheit => this == TemperatureUnits.fahrenheit;
  bool get isCelsius => this == TemperatureUnits.celsius;
}

@JsonSerializable()
class Temperature extends Equatable {
  const Temperature({required this.value});

  factory Temperature.fromJson(Map<String, dynamic> json) =>
      _$TemperatureFromJson(json);

  final double value;

  Map<String, dynamic> toJson() => _$TemperatureToJson(this);

  @override
  List<Object> get props => [value];
}

@JsonSerializable(explicitToJson: true)
class Weather extends Equatable {
  const Weather({
    required this.condition,
    required this.lastUpdated,
    required this.location,
    required this.temperature,
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

  factory Weather.fromRepository(weather_repository.Weather weather) {
    return Weather(
      condition: weather.condition,
      lastUpdated: DateTime.now(),
      location: weather.location,
      temperature: Temperature(value: weather.temperature),
      isDay: weather.isDay,
      windSpeed: weather.windSpeed,
      windDirection: weather.windDirection,
      humidity: weather.humidity,
      feelsLike: weather.feelsLike,
      uvIndex: weather.uvIndex,
      aqi: weather.aqi,
      pm25: weather.pm25,
      hourlyForecast: weather.hourlyForecast,
      dailyForecast: weather.dailyForecast,
    );
  }

  static final empty = Weather(
    condition: WeatherCondition.unknown,
    lastUpdated: DateTime(0),
    temperature: const Temperature(value: 0),
    location: '--',
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

  final WeatherCondition condition;
  final DateTime lastUpdated;
  final String location;
  final Temperature temperature;
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
        condition,
        lastUpdated,
        location,
        temperature,
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

  Map<String, dynamic> toJson() => _$WeatherToJson(this);

  Weather copyWith({
    WeatherCondition? condition,
    DateTime? lastUpdated,
    String? location,
    Temperature? temperature,
    bool? isDay,
    double? windSpeed,
    double? windDirection,
    double? humidity,
    double? feelsLike,
    double? uvIndex,
    double? aqi,
    double? pm25,
    List<HourlyWeather>? hourlyForecast,
    List<DailyWeather>? dailyForecast,
  }) {
    return Weather(
      condition: condition ?? this.condition,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      location: location ?? this.location,
      temperature: temperature ?? this.temperature,
      isDay: isDay ?? this.isDay,
      windSpeed: windSpeed ?? this.windSpeed,
      windDirection: windDirection ?? this.windDirection,
      humidity: humidity ?? this.humidity,
      feelsLike: feelsLike ?? this.feelsLike,
      uvIndex: uvIndex ?? this.uvIndex,
      aqi: aqi ?? this.aqi,
      pm25: pm25 ?? this.pm25,
      hourlyForecast: hourlyForecast ?? this.hourlyForecast,
      dailyForecast: dailyForecast ?? this.dailyForecast,
    );
  }
}
