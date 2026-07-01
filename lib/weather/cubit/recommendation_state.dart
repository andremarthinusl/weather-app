part of 'recommendation_cubit.dart';

enum RecommendationStatus { initial, loading, success, failure }

class RecommendationState extends Equatable {
  const RecommendationState({
    this.status = RecommendationStatus.initial,
    this.places = const [],
    this.keywordUsed = '',
  });

  final RecommendationStatus status;
  final List<Place> places;
  final String keywordUsed;

  RecommendationState copyWith({
    RecommendationStatus? status,
    List<Place>? places,
    String? keywordUsed,
  }) {
    return RecommendationState(
      status: status ?? this.status,
      places: places ?? this.places,
      keywordUsed: keywordUsed ?? this.keywordUsed,
    );
  }

  @override
  List<Object> get props => [status, places, keywordUsed];
}
