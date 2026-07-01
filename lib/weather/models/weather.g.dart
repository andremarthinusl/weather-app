// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Temperature _$TemperatureFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Temperature', json, ($checkedConvert) {
      final val = Temperature(
        value: $checkedConvert('value', (v) => (v as num).toDouble()),
      );
      return val;
    });

Map<String, dynamic> _$TemperatureToJson(Temperature instance) =>
    <String, dynamic>{'value': instance.value};

Weather _$WeatherFromJson(Map<String, dynamic> json) => $checkedCreate(
  'Weather',
  json,
  ($checkedConvert) {
    final val = Weather(
      condition: $checkedConvert(
        'condition',
        (v) => $enumDecode(_$WeatherConditionEnumMap, v),
      ),
      lastUpdated: $checkedConvert(
        'last_updated',
        (v) => DateTime.parse(v as String),
      ),
      location: $checkedConvert('location', (v) => v as String),
      temperature: $checkedConvert(
        'temperature',
        (v) => Temperature.fromJson(v as Map<String, dynamic>),
      ),
      isDay: $checkedConvert('is_day', (v) => v as bool),
      windSpeed: $checkedConvert('wind_speed', (v) => (v as num).toDouble()),
      windDirection: $checkedConvert(
        'wind_direction',
        (v) => (v as num).toDouble(),
      ),
      humidity: $checkedConvert('humidity', (v) => (v as num).toDouble()),
      feelsLike: $checkedConvert('feels_like', (v) => (v as num).toDouble()),
      uvIndex: $checkedConvert('uv_index', (v) => (v as num).toDouble()),
      aqi: $checkedConvert('aqi', (v) => (v as num).toDouble()),
      pm25: $checkedConvert('pm25', (v) => (v as num).toDouble()),
      hourlyForecast: $checkedConvert(
        'hourly_forecast',
        (v) => (v as List<dynamic>)
            .map((e) => HourlyWeather.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
      dailyForecast: $checkedConvert(
        'daily_forecast',
        (v) => (v as List<dynamic>)
            .map((e) => DailyWeather.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'lastUpdated': 'last_updated',
    'isDay': 'is_day',
    'windSpeed': 'wind_speed',
    'windDirection': 'wind_direction',
    'feelsLike': 'feels_like',
    'uvIndex': 'uv_index',
    'hourlyForecast': 'hourly_forecast',
    'dailyForecast': 'daily_forecast',
  },
);

Map<String, dynamic> _$WeatherToJson(Weather instance) => <String, dynamic>{
  'condition': _$WeatherConditionEnumMap[instance.condition]!,
  'last_updated': instance.lastUpdated.toIso8601String(),
  'location': instance.location,
  'temperature': instance.temperature.toJson(),
  'is_day': instance.isDay,
  'wind_speed': instance.windSpeed,
  'wind_direction': instance.windDirection,
  'humidity': instance.humidity,
  'feels_like': instance.feelsLike,
  'uv_index': instance.uvIndex,
  'aqi': instance.aqi,
  'pm25': instance.pm25,
  'hourly_forecast': instance.hourlyForecast.map((e) => e.toJson()).toList(),
  'daily_forecast': instance.dailyForecast.map((e) => e.toJson()).toList(),
};

const _$WeatherConditionEnumMap = {
  WeatherCondition.clear: 'clear',
  WeatherCondition.rainy: 'rainy',
  WeatherCondition.cloudy: 'cloudy',
  WeatherCondition.snowy: 'snowy',
  WeatherCondition.unknown: 'unknown',
};
