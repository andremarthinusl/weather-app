import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_repository/weather_repository.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this._weatherRepository) : super(const SearchState());

  final WeatherRepository _weatherRepository;
  Timer? _debounce;

  void onSearchQueryChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    
    if (query.isEmpty) {
      emit(const SearchState());
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      emit(state.copyWith(status: SearchStatus.loading));
      try {
        final locations = await _weatherRepository.searchLocations(query);
        emit(state.copyWith(status: SearchStatus.success, locations: locations));
      } catch (_) {
        emit(state.copyWith(status: SearchStatus.failure));
      }
    });
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
