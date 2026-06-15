// ignore_for_file: prefer_const_constructors
import 'package:mocktail/mocktail.dart';
import 'package:open_meteo_api/open_meteo_api.dart' as open_meteo_api;
import 'package:test/test.dart';
import 'package:weather_repository/weather_repository.dart';

class MockOpenMeteoApiClient extends Mock
    implements open_meteo_api.OpenMeteoApiClient {}

class MockLocation extends Mock implements open_meteo_api.Location {}

class MockWeather extends Mock implements open_meteo_api.Weather {}

class MockHourlyForecast extends Mock implements open_meteo_api.HourlyForecast {}

class MockDailyForecast extends Mock implements open_meteo_api.DailyForecast {}

class MockWeatherData extends Mock implements open_meteo_api.WeatherData {}

void main() {
  group('WeatherRepository', () {
    late open_meteo_api.OpenMeteoApiClient weatherApiClient;
    late WeatherRepository weatherRepository;

    setUp(() {
      weatherApiClient = MockOpenMeteoApiClient();
      weatherRepository = WeatherRepository(
        weatherApiClient: weatherApiClient,
      );
    });

    group('constructor', () {
      test('instantiates internal weather api client when not injected', () {
        expect(WeatherRepository(), isNotNull);
      });
    });

    group('getWeather', () {
      const city = 'chicago';
      const latitude = 41.85003;
      const longitude = -87.65005;

      test('calls locationSearch with correct city', () async {
        try {
          await weatherRepository.getWeather(city);
        } catch (_) {}
        verify(() => weatherApiClient.locationSearch(city)).called(1);
      });

      test('throws when locationSearch fails', () async {
        final exception = Exception('oops');
        when(() => weatherApiClient.locationSearch(any())).thenThrow(exception);
        expect(
          () async => weatherRepository.getWeather(city),
          throwsA(exception),
        );
      });

      test('calls getWeather with correct latitude/longitude', () async {
        final location = MockLocation();
        when(() => location.latitude).thenReturn(latitude);
        when(() => location.longitude).thenReturn(longitude);
        when(() => weatherApiClient.locationSearch(any())).thenAnswer(
          (_) async => location,
        );
        try {
          await weatherRepository.getWeather(city);
        } catch (_) {}
        verify(
          () => weatherApiClient.getWeather(
            latitude: latitude,
            longitude: longitude,
          ),
        ).called(1);
      });

      test('throws when getWeather fails', () async {
        final exception = Exception('oops');
        final location = MockLocation();
        when(() => location.latitude).thenReturn(latitude);
        when(() => location.longitude).thenReturn(longitude);
        when(() => weatherApiClient.locationSearch(any())).thenAnswer(
          (_) async => location,
        );
        when(
          () => weatherApiClient.getWeather(
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
          ),
        ).thenThrow(exception);
        expect(
          () async => weatherRepository.getWeather(city),
          throwsA(exception),
        );
      });

      test('returns correct weather on success (clear)', () async {
        final location = MockLocation();
        final weatherData = MockWeatherData();
        final current = MockWeather();
        final hourly = MockHourlyForecast();
        final daily = MockDailyForecast();
        
        when(() => current.temperature).thenReturn(42.42);
        when(() => current.weatherCode).thenReturn(0);
        when(() => current.isDay).thenReturn(1);
        when(() => current.windSpeed).thenReturn(10.0);
        when(() => current.windDirection).thenReturn(180.0);

        when(() => hourly.time).thenReturn(['2022-09-12T00:00']);
        when(() => hourly.temperature2m).thenReturn([42.42]);
        when(() => hourly.weatherCode).thenReturn([0]);

        when(() => daily.time).thenReturn(['2022-09-12']);
        when(() => daily.temperature2mMax).thenReturn([42.42]);
        when(() => daily.temperature2mMin).thenReturn([42.42]);
        when(() => daily.weatherCode).thenReturn([0]);

        when(() => weatherData.currentWeather).thenReturn(current);
        when(() => weatherData.hourlyForecast).thenReturn(hourly);
        when(() => weatherData.dailyForecast).thenReturn(daily);

        when(() => location.name).thenReturn(city);
        when(() => location.latitude).thenReturn(latitude);
        when(() => location.longitude).thenReturn(longitude);
        
        when(() => weatherApiClient.locationSearch(any())).thenAnswer(
          (_) async => location,
        );
        when(
          () => weatherApiClient.getWeather(
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
          ),
        ).thenAnswer((_) async => weatherData);
        final actual = await weatherRepository.getWeather(city);
        expect(
          actual,
          Weather(
            temperature: 42.42,
            location: city,
            condition: WeatherCondition.clear,
            isDay: true,
            windSpeed: 10.0,
            windDirection: 180.0,
            hourlyForecast: [
              HourlyWeather(
                time: DateTime.parse('2022-09-12T00:00'),
                temperature: 42.42,
                condition: WeatherCondition.clear,
              )
            ],
            dailyForecast: [
              DailyWeather(
                time: DateTime.parse('2022-09-12'),
                temperatureMax: 42.42,
                temperatureMin: 42.42,
                condition: WeatherCondition.clear,
              )
            ],
          ),
        );
      });

      test('returns correct weather on success (cloudy)', () async {
        final location = MockLocation();
        final weatherData = MockWeatherData();
        final current = MockWeather();
        final hourly = MockHourlyForecast();
        final daily = MockDailyForecast();

        when(() => current.temperature).thenReturn(42.42);
        when(() => current.weatherCode).thenReturn(1);
        when(() => current.isDay).thenReturn(1);
        when(() => current.windSpeed).thenReturn(10.0);
        when(() => current.windDirection).thenReturn(180.0);

        when(() => hourly.time).thenReturn(['2022-09-12T00:00']);
        when(() => hourly.temperature2m).thenReturn([42.42]);
        when(() => hourly.weatherCode).thenReturn([1]);

        when(() => daily.time).thenReturn(['2022-09-12']);
        when(() => daily.temperature2mMax).thenReturn([42.42]);
        when(() => daily.temperature2mMin).thenReturn([42.42]);
        when(() => daily.weatherCode).thenReturn([1]);

        when(() => weatherData.currentWeather).thenReturn(current);
        when(() => weatherData.hourlyForecast).thenReturn(hourly);
        when(() => weatherData.dailyForecast).thenReturn(daily);

        when(() => location.name).thenReturn(city);
        when(() => location.latitude).thenReturn(latitude);
        when(() => location.longitude).thenReturn(longitude);

        when(() => weatherApiClient.locationSearch(any())).thenAnswer(
          (_) async => location,
        );
        when(
          () => weatherApiClient.getWeather(
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
          ),
        ).thenAnswer((_) async => weatherData);
        final actual = await weatherRepository.getWeather(city);
        expect(
          actual.condition,
          WeatherCondition.cloudy,
        );
      });

      test('returns correct weather on success (rainy)', () async {
        final location = MockLocation();
        final weatherData = MockWeatherData();
        final current = MockWeather();
        final hourly = MockHourlyForecast();
        final daily = MockDailyForecast();

        when(() => current.temperature).thenReturn(42.42);
        when(() => current.weatherCode).thenReturn(51);
        when(() => current.isDay).thenReturn(1);
        when(() => current.windSpeed).thenReturn(10.0);
        when(() => current.windDirection).thenReturn(180.0);

        when(() => hourly.time).thenReturn(['2022-09-12T00:00']);
        when(() => hourly.temperature2m).thenReturn([42.42]);
        when(() => hourly.weatherCode).thenReturn([51]);

        when(() => daily.time).thenReturn(['2022-09-12']);
        when(() => daily.temperature2mMax).thenReturn([42.42]);
        when(() => daily.temperature2mMin).thenReturn([42.42]);
        when(() => daily.weatherCode).thenReturn([51]);

        when(() => weatherData.currentWeather).thenReturn(current);
        when(() => weatherData.hourlyForecast).thenReturn(hourly);
        when(() => weatherData.dailyForecast).thenReturn(daily);

        when(() => location.name).thenReturn(city);
        when(() => location.latitude).thenReturn(latitude);
        when(() => location.longitude).thenReturn(longitude);

        when(() => weatherApiClient.locationSearch(any())).thenAnswer(
          (_) async => location,
        );
        when(
          () => weatherApiClient.getWeather(
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
          ),
        ).thenAnswer((_) async => weatherData);
        final actual = await weatherRepository.getWeather(city);
        expect(
          actual.condition,
          WeatherCondition.rainy,
        );
      });

      test('returns correct weather on success (snowy)', () async {
        final location = MockLocation();
        final weatherData = MockWeatherData();
        final current = MockWeather();
        final hourly = MockHourlyForecast();
        final daily = MockDailyForecast();

        when(() => current.temperature).thenReturn(42.42);
        when(() => current.weatherCode).thenReturn(71);
        when(() => current.isDay).thenReturn(1);
        when(() => current.windSpeed).thenReturn(10.0);
        when(() => current.windDirection).thenReturn(180.0);

        when(() => hourly.time).thenReturn(['2022-09-12T00:00']);
        when(() => hourly.temperature2m).thenReturn([42.42]);
        when(() => hourly.weatherCode).thenReturn([71]);

        when(() => daily.time).thenReturn(['2022-09-12']);
        when(() => daily.temperature2mMax).thenReturn([42.42]);
        when(() => daily.temperature2mMin).thenReturn([42.42]);
        when(() => daily.weatherCode).thenReturn([71]);

        when(() => weatherData.currentWeather).thenReturn(current);
        when(() => weatherData.hourlyForecast).thenReturn(hourly);
        when(() => weatherData.dailyForecast).thenReturn(daily);

        when(() => location.name).thenReturn(city);
        when(() => location.latitude).thenReturn(latitude);
        when(() => location.longitude).thenReturn(longitude);

        when(() => weatherApiClient.locationSearch(any())).thenAnswer(
          (_) async => location,
        );
        when(
          () => weatherApiClient.getWeather(
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
          ),
        ).thenAnswer((_) async => weatherData);
        final actual = await weatherRepository.getWeather(city);
        expect(
          actual.condition,
          WeatherCondition.snowy,
        );
      });

      test('returns correct weather on success (unknown)', () async {
        final location = MockLocation();
        final weatherData = MockWeatherData();
        final current = MockWeather();
        final hourly = MockHourlyForecast();
        final daily = MockDailyForecast();

        when(() => current.temperature).thenReturn(42.42);
        when(() => current.weatherCode).thenReturn(-1);
        when(() => current.isDay).thenReturn(1);
        when(() => current.windSpeed).thenReturn(10.0);
        when(() => current.windDirection).thenReturn(180.0);

        when(() => hourly.time).thenReturn(['2022-09-12T00:00']);
        when(() => hourly.temperature2m).thenReturn([42.42]);
        when(() => hourly.weatherCode).thenReturn([-1]);

        when(() => daily.time).thenReturn(['2022-09-12']);
        when(() => daily.temperature2mMax).thenReturn([42.42]);
        when(() => daily.temperature2mMin).thenReturn([42.42]);
        when(() => daily.weatherCode).thenReturn([-1]);

        when(() => weatherData.currentWeather).thenReturn(current);
        when(() => weatherData.hourlyForecast).thenReturn(hourly);
        when(() => weatherData.dailyForecast).thenReturn(daily);

        when(() => location.name).thenReturn(city);
        when(() => location.latitude).thenReturn(latitude);
        when(() => location.longitude).thenReturn(longitude);

        when(() => weatherApiClient.locationSearch(any())).thenAnswer(
          (_) async => location,
        );
        when(
          () => weatherApiClient.getWeather(
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
          ),
        ).thenAnswer((_) async => weatherData);
        final actual = await weatherRepository.getWeather(city);
        expect(
          actual.condition,
          WeatherCondition.unknown,
        );
      });
    });

    group('dispose', () {
      test('closes the weather api client', () {
        weatherRepository.dispose();
        verify(weatherApiClient.close).called(1);
      });
    });
  });
}
