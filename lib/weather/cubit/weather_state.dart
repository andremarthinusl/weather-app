part of 'weather_cubit.dart';

enum WeatherStatus { initial, loading, success, failure }

extension WeatherStatusX on WeatherStatus {
  bool get isInitial => this == WeatherStatus.initial;
  bool get isLoading => this == WeatherStatus.loading;
  bool get isSuccess => this == WeatherStatus.success;
  bool get isFailure => this == WeatherStatus.failure;
}

@JsonSerializable()
final class WeatherState extends Equatable {
  WeatherState({
    this.status = WeatherStatus.initial,
    this.temperatureUnits = TemperatureUnits.celsius,
    Weather? weather,
    this.favoriteCities = const [],
  }) : weather = weather ?? Weather.empty;

  factory WeatherState.fromJson(Map<String, dynamic> json) =>
      _$WeatherStateFromJson(json);

  final WeatherStatus status;
  final Weather weather;
  final TemperatureUnits temperatureUnits;
  final List<String> favoriteCities;

  WeatherState copyWith({
    WeatherStatus? status,
    TemperatureUnits? temperatureUnits,
    Weather? weather,
    List<String>? favoriteCities,
  }) {
    return WeatherState(
      status: status ?? this.status,
      temperatureUnits: temperatureUnits ?? this.temperatureUnits,
      weather: weather ?? this.weather,
      favoriteCities: favoriteCities ?? this.favoriteCities,
    );
  }

  Map<String, dynamic> toJson() => _$WeatherStateToJson(this);

  @override
  List<Object?> get props => [status, temperatureUnits, weather, favoriteCities];
}
