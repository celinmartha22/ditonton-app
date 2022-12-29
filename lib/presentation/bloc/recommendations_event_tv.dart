part of 'recommendations_bloc_tv.dart';

abstract class RecommendationsEventTv extends Equatable {
  const RecommendationsEventTv();

  @override
  List<Object> get props => [];
}

class GetRecommendationsTv extends RecommendationsEventTv {
    final String id;

  GetRecommendationsTv(this.id);

  @override
  List<Object> get props => [id];
}