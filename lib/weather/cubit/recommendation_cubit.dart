import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../places/models/place.dart';
import '../../../places/repository/places_repository.dart';

import 'package:weather_repository/weather_repository.dart' show WeatherCondition;

part 'recommendation_state.dart';

class RecommendationCubit extends Cubit<RecommendationState> {
  RecommendationCubit(this._placesRepository) : super(const RecommendationState());

  final PlacesRepository _placesRepository;

  Future<void> getRecommendations(WeatherCondition condition, bool isDay, String cityName) async {
    emit(state.copyWith(status: RecommendationStatus.loading));
    try {
      final keyword = _mapWeatherToKeyword(condition, isDay);
      final places = await _placesRepository.getRecommendations(keyword, cityName);
      
      // Get photo URLs properly
      final mappedPlaces = places.map((p) {
        if (p.photoUrl != null && !p.photoUrl!.startsWith('http')) {
          return Place(
            id: p.id,
            name: p.name,
            rating: p.rating,
            address: p.address,
            isOpen: p.isOpen,
            photoUrl: _placesRepository.getPhotoUrl(p.photoUrl!),
            lat: p.lat,
            lng: p.lng,
          );
        }
        return p;
      }).toList();

      emit(state.copyWith(
        status: RecommendationStatus.success,
        places: mappedPlaces,
        keywordUsed: keyword,
      ));
    } catch (e) {
      emit(state.copyWith(status: RecommendationStatus.failure));
    }
  }

  String _mapWeatherToKeyword(WeatherCondition condition, bool isDay) {
    if (condition == WeatherCondition.unknown) return 'Cafe';

    switch (condition) {
      case WeatherCondition.rainy:
      case WeatherCondition.snowy:
        return isDay ? 'Soto OR Ramen' : 'Bakso OR Ramen OR Cafe';
      case WeatherCondition.clear:
        return isDay ? 'Es krim OR Minuman Dingin OR Seafood' : 'Angkringan OR Street Food OR Sate';
      case WeatherCondition.cloudy:
        return isDay ? 'Coffee Shop OR Dessert' : 'Cafe OR Roti Bakar';
      default:
        return 'Restaurant';
    }
  }
}
