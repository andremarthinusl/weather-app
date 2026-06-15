import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:open_meteo_api/open_meteo_api.dart';

/// Exception thrown when locationSearch fails.
class LocationRequestFailure implements Exception {}

/// Exception thrown when the provided location is not found.
class LocationNotFoundFailure implements Exception {}

/// Exception thrown when getWeather fails.
class WeatherRequestFailure implements Exception {}

/// Exception thrown when weather for provided location is not found.
class WeatherNotFoundFailure implements Exception {}

/// {@template open_meteo_api_client}
/// Dart API Client which wraps the [Open Meteo API](https://open-meteo.com).
/// {@endtemplate}
class OpenMeteoApiClient {
  /// {@macro open_meteo_api_client}
  OpenMeteoApiClient({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  static const _baseUrlWeather = 'api.open-meteo.com';
  static const _baseUrlGeocoding = 'geocoding-api.open-meteo.com';
  static const _baseUrlAirQuality = 'air-quality-api.open-meteo.com';

  final http.Client _httpClient;

  /// Finds a [Location] `/v1/search/?name=(query)`.
  Future<Location> locationSearch(String query) async {
    final locationRequest = Uri.https(
      _baseUrlGeocoding,
      '/v1/search',
      {'name': query, 'count': '1'},
    );

    final locationResponse = await _httpClient.get(locationRequest);

    if (locationResponse.statusCode != 200) {
      throw LocationRequestFailure();
    }

    final locationJson = jsonDecode(locationResponse.body) as Map;

    if (!locationJson.containsKey('results')) throw LocationNotFoundFailure();

    final results = locationJson['results'] as List;

    if (results.isEmpty) throw LocationNotFoundFailure();

    return Location.fromJson(results.first as Map<String, dynamic>);
  }

  /// Finds multiple [Location]s `/v1/search/?name=(query)`.
  Future<List<Location>> searchLocations(String query, {int count = 5}) async {
    final locationRequest = Uri.https(
      _baseUrlGeocoding,
      '/v1/search',
      {'name': query, 'count': '$count'},
    );

    final locationResponse = await _httpClient.get(locationRequest);

    if (locationResponse.statusCode != 200) {
      throw LocationRequestFailure();
    }

    final locationJson = jsonDecode(locationResponse.body) as Map;

    if (!locationJson.containsKey('results')) return [];

    final results = locationJson['results'] as List;

    return results
        .map((dynamic result) => Location.fromJson(result as Map<String, dynamic>))
        .toList();
  }

  /// Fetches [WeatherData] for a given [latitude] and [longitude].
  Future<WeatherData> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    final weatherRequest = Uri.https(_baseUrlWeather, 'v1/forecast', {
      'latitude': '$latitude',
      'longitude': '$longitude',
      'current_weather': 'true',
      'hourly': 'temperature_2m,weathercode,relative_humidity_2m,apparent_temperature,uv_index',
      'daily': 'weathercode,temperature_2m_max,temperature_2m_min',
      'timezone': 'auto',
    });

    final weatherResponse = await _httpClient.get(weatherRequest);

    if (weatherResponse.statusCode != 200) {
      throw WeatherRequestFailure();
    }

    final bodyJson = jsonDecode(weatherResponse.body) as Map<String, dynamic>;

    if (!bodyJson.containsKey('current_weather')) {
      throw WeatherNotFoundFailure();
    }

    final weatherJson = bodyJson['current_weather'] as Map<String, dynamic>;
    final hourlyJson = bodyJson['hourly'] as Map<String, dynamic>;
    final dailyJson = bodyJson['daily'] as Map<String, dynamic>;

    return WeatherData(
      currentWeather: Weather.fromJson(weatherJson),
      hourlyForecast: HourlyForecast.fromJson(hourlyJson),
      dailyForecast: DailyForecast.fromJson(dailyJson),
    );
  }

  /// Fetches [AirQualityResponse] for a given [latitude] and [longitude].
  Future<AirQualityResponse> getAirQuality({
    required double latitude,
    required double longitude,
  }) async {
    final aqiRequest = Uri.https(_baseUrlAirQuality, 'v1/air-quality', {
      'latitude': '$latitude',
      'longitude': '$longitude',
      'current': 'pm2_5,us_aqi',
    });

    final aqiResponse = await _httpClient.get(aqiRequest);

    if (aqiResponse.statusCode != 200) {
      throw WeatherRequestFailure();
    }

    final bodyJson = jsonDecode(aqiResponse.body) as Map<String, dynamic>;

    if (!bodyJson.containsKey('current')) {
      throw WeatherNotFoundFailure();
    }

    return AirQualityResponse.fromJson(bodyJson);
  }

  /// Closes the underlying http client.
  void close() {
    _httpClient.close();
  }
}
