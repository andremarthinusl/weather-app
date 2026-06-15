import 'package:json_annotation/json_annotation.dart';

part 'air_quality.g.dart';

@JsonSerializable()
class AirQuality {
  const AirQuality({required this.pm25, required this.usAqi});

  factory AirQuality.fromJson(Map<String, dynamic> json) =>
      _$AirQualityFromJson(json);

  @JsonKey(name: 'pm2_5')
  final double pm25;
  @JsonKey(name: 'us_aqi')
  final double usAqi;
}

@JsonSerializable()
class AirQualityResponse {
  const AirQualityResponse({required this.current});

  factory AirQualityResponse.fromJson(Map<String, dynamic> json) =>
      _$AirQualityResponseFromJson(json);

  final AirQuality current;
}
