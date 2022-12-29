part of 'recommendations_bloc_movie.dart';

abstract class RecommendationsStateMovie extends Equatable {
 const RecommendationsStateMovie();
  @override
  List<Object> get props => [];
}

class RecommendationsEmpty extends RecommendationsStateMovie {
  
}

class RecommendationsLoading extends RecommendationsStateMovie {
  
}
class RecommendationsError extends RecommendationsStateMovie {
  final String message;
  RecommendationsError(this.message);

  @override
  List<Object> get props => [message];
}

class RecommendationsHasData extends RecommendationsStateMovie {
  final List<Movie> result;

  RecommendationsHasData(this.result);

  @override
  List<Object> get props => [result];
}