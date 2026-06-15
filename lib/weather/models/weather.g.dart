// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'weather.dart';

Temperature _$TemperatureFromJson(Map<String, dynamic> json) => Temperature(
      value: (json['value'] as num).toDouble(),
    );

Map<String, dynamic> _$TemperatureToJson(Temperature instance) =>
    <String, dynamic>{
      'value': instance.value,
    };

Weather _$WeatherFromJson(Map<String, dynamic> json) => Weather(
      condition: $enumDecode(_$WeatherConditionEnumMap, json['condition']),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      location: json['location'] as String,
      temperature:
          Temperature.fromJson(json['temperature'] as Map<String, dynamic>),
      isDay: json['isDay'] as bool,
      windSpeed: (json['windSpeed'] as num).toDouble(),
      windDirection: (json['windDirection'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
      feelsLike: (json['feelsLike'] as num).toDouble(),
      uvIndex: (json['uvIndex'] as num).toDouble(),
      aqi: (json['aqi'] as num?)?.toDouble() ?? 0.0,
      pm25: (json['pm25'] as num?)?.toDouble() ?? 0.0,
      hourlyForecast: (json['hourlyForecast'] as List<dynamic>)
          .map((e) => weather_repository.HourlyWeather.fromJson(
              e as Map<String, dynamic>))
          .toList(),
      dailyForecast: (json['dailyForecast'] as List<dynamic>)
          .map((e) => weather_repository.DailyWeather.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WeatherToJson(Weather instance) => <String, dynamic>{
      'condition': _$WeatherConditionEnumMap[instance.condition]!,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'location': instance.location,
      'temperature': instance.temperature.toJson(),
      'isDay': instance.isDay,
      'windSpeed': instance.windSpeed,
      'windDirection': instance.windDirection,
      'humidity': instance.humidity,
      'feelsLike': instance.feelsLike,
      'uvIndex': instance.uvIndex,
      'aqi': instance.aqi,
      'pm25': instance.pm25,
      'hourlyForecast': instance.hourlyForecast.map((e) => e.toJson()).toList(),
      'dailyForecast': instance.dailyForecast.map((e) => e.toJson()).toList(),
    };

const _$WeatherConditionEnumMap = {
  WeatherCondition.clear: 'clear',
  WeatherCondition.rainy: 'rainy',
  WeatherCondition.cloudy: 'cloudy',
  WeatherCondition.snowy: 'snowy',
  WeatherCondition.unknown: 'unknown',
};

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }
  return enumValues.entries
      .singleWhere((e) => e.value == source,
          orElse: () => throw ArgumentError(
              '`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}'))
      .key;
}
