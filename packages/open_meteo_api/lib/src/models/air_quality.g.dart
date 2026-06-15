// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'air_quality.dart';

AirQuality _$AirQualityFromJson(Map<String, dynamic> json) => AirQuality(
      pm25: (json['pm2_5'] as num).toDouble(),
      usAqi: (json['us_aqi'] as num).toDouble(),
    );

Map<String, dynamic> _$AirQualityToJson(AirQuality instance) => <String, dynamic>{
      'pm2_5': instance.pm25,
      'us_aqi': instance.usAqi,
    };

AirQualityResponse _$AirQualityResponseFromJson(Map<String, dynamic> json) =>
    AirQualityResponse(
      current: AirQuality.fromJson(json['current'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AirQualityResponseToJson(AirQualityResponse instance) =>
    <String, dynamic>{
      'current': instance.current,
    };
