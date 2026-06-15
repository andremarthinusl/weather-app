// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'weather.dart';

Weather _$WeatherFromJson(Map<String, dynamic> json) => Weather(
      temperature: (json['temperature'] as num).toDouble(),
      weatherCode: (json['weathercode'] as num).toDouble(),
      windSpeed: (json['windspeed'] as num?)?.toDouble() ?? 0.0,
      windDirection: (json['winddirection'] as num?)?.toDouble() ?? 0.0,
      isDay: (json['is_day'] as num?)?.toInt() ?? 1,
    );

HourlyForecast _$HourlyForecastFromJson(Map<String, dynamic> json) => HourlyForecast(
      time: (json['time'] as List<dynamic>).map((e) => e as String).toList(),
      temperature2m: (json['temperature_2m'] as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
      weatherCode: (json['weathercode'] as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
      relativeHumidity2m: (json['relative_humidity_2m'] as List<dynamic>?)?.map((e) => (e as num).toDouble()).toList() ?? const [],
      apparentTemperature: (json['apparent_temperature'] as List<dynamic>?)?.map((e) => (e as num).toDouble()).toList() ?? const [],
      uvIndex: (json['uv_index'] as List<dynamic>?)?.map((e) => (e as num).toDouble()).toList() ?? const [],
    );

DailyForecast _$DailyForecastFromJson(Map<String, dynamic> json) => DailyForecast(
      time: (json['time'] as List<dynamic>).map((e) => e as String).toList(),
      weatherCode: (json['weathercode'] as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
      temperature2mMax: (json['temperature_2m_max'] as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
      temperature2mMin: (json['temperature_2m_min'] as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
    );
