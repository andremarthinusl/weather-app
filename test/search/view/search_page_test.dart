import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_weather/search/search.dart';
import 'package:flutter_weather/weather/weather.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_repository/weather_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockWeatherCubit extends MockCubit<WeatherState> implements WeatherCubit {}
class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  group('SearchPage', () {
    late WeatherCubit weatherCubit;
    late WeatherRepository weatherRepository;

    setUp(() {
      weatherCubit = MockWeatherCubit();
      weatherRepository = MockWeatherRepository();
      when(() => weatherCubit.fetchWeather(any())).thenAnswer((_) async {});
      when(() => weatherCubit.state).thenReturn(WeatherState());
    });

    testWidgets('is routable', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: weatherRepository,
          child: MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(SearchPage.route(weatherCubit));
                  },
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      expect(find.byType(SearchPage), findsOneWidget);
    });

    testWidgets('returns selected text when popped', (tester) async {
      String? location;
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: weatherRepository,
          child: MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                floatingActionButton: FloatingActionButton(
                  onPressed: () async {
                    location = await Navigator.of(context).push(
                      SearchPage.route(weatherCubit),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Chicago');
      await tester.tap(find.byKey(const Key('searchPage_search_iconButton')));
      await tester.pumpAndSettle();
      expect(find.byType(SearchPage), findsNothing);
      expect(location, 'Chicago');
    });
  });
}
