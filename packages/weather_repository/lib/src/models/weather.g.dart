// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'weather.dart';

Weather _$WeatherFromJson(Map<String, dynamic> json) => Weather(
      location: json['location'] as String,
      temperature: (json['temperature'] as num).toDouble(),
      condition: $enumDecode(_$WeatherConditionEnumMap, json['condition']),
      isDay: json['isDay'] as bool,
      windSpeed: (json['windSpeed'] as num).toDouble(),
      windDirection: (json['windDirection'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
      feelsLike: (json['feelsLike'] as num).toDouble(),
      uvIndex: (json['uvIndex'] as num).toDouble(),
      aqi: (json['aqi'] as num?)?.toDouble() ?? 0.0,
      pm25: (json['pm25'] as num?)?.toDouble() ?? 0.0,
      hourlyForecast: (json['hourlyForecast'] as List<dynamic>)
          .map((e) => HourlyWeather.fromJson(e as Map<String, dynamic>))
          .toList(),
      dailyForecast: (json['dailyForecast'] as List<dynamic>)
          .map((e) => DailyWeather.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WeatherToJson(Weather instance) => <String, dynamic>{
      'location': instance.location,
      'temperature': instance.temperature,
      'condition': _$WeatherConditionEnumMap[instance.condition]!,
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

HourlyWeather _$HourlyWeatherFromJson(Map<String, dynamic> json) => HourlyWeather(
      time: DateTime.parse(json['time'] as String),
      temperature: (json['temperature'] as num).toDouble(),
      condition: $enumDecode(_$WeatherConditionEnumMap, json['condition']),
    );

Map<String, dynamic> _$HourlyWeatherToJson(HourlyWeather instance) => <String, dynamic>{
      'time': instance.time.toIso8601String(),
      'temperature': instance.temperature,
      'condition': _$WeatherConditionEnumMap[instance.condition]!,
    };

DailyWeather _$DailyWeatherFromJson(Map<String, dynamic> json) => DailyWeather(
      time: DateTime.parse(json['time'] as String),
      temperatureMax: (json['temperatureMax'] as num).toDouble(),
      temperatureMin: (json['temperatureMin'] as num).toDouble(),
      condition: $enumDecode(_$WeatherConditionEnumMap, json['condition']),
    );

Map<String, dynamic> _$DailyWeatherToJson(DailyWeather instance) => <String, dynamic>{
      'time': instance.time.toIso8601String(),
      'temperatureMax': instance.temperatureMax,
      'temperatureMin': instance.temperatureMin,
      'condition': _$WeatherConditionEnumMap[instance.condition]!,
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
