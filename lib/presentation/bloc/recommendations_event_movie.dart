part of 'recommendations_bloc_movie.dart';

abstract class RecommendationsEventMovie extends Equatable {
  const RecommendationsEventMovie();

  @override
  List<Object> get props => [];
}

class GetRecommendationsMovie extends RecommendationsEventMovie {
  final String id;

  GetRecommendationsMovie(this.id);

  @override
  List<Object> get props => [id];
}
