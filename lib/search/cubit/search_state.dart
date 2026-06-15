part of 'search_cubit.dart';

enum SearchStatus { initial, loading, success, failure }

class SearchState extends Equatable {
  const SearchState({
    this.status = SearchStatus.initial,
    this.locations = const [],
  });

  final SearchStatus status;
  final List<String> locations;

  SearchState copyWith({
    SearchStatus? status,
    List<String>? locations,
  }) {
    return SearchState(
      status: status ?? this.status,
      locations: locations ?? this.locations,
    );
  }

  @override
  List<Object> get props => [status, locations];
}
