import 'package:open_meteo_api/open_meteo_api.dart';
import 'package:test/test.dart';

void main() {
  group('Weather', () {
    group('fromJson', () {
      test('returns correct Weather object', () {
        expect(
          Weather.fromJson(
            <String, dynamic>{
              'temperature': 15.3,
              'weathercode': 63,
              'windspeed': 10.5,
              'winddirection': 250.0,
              'is_day': 1,
            },
          ),
          isA<Weather>()
              .having((w) => w.temperature, 'temperature', 15.3)
              .having((w) => w.weatherCode, 'weatherCode', 63)
              .having((w) => w.windSpeed, 'windSpeed', 10.5)
              .having((w) => w.windDirection, 'windDirection', 250.0)
              .having((w) => w.isDay, 'isDay', 1),
        );
      });
    });
  });
}
