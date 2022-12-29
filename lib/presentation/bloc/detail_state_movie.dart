part of 'detail_bloc_movie.dart';

abstract class DetailStateMovie extends Equatable {
  const DetailStateMovie();
  @override
  List<Object> get props => [];
}

class DetailEmpty extends DetailStateMovie {}

class RecommendationEmpty extends DetailStateMovie {}

class DetailLoading extends DetailStateMovie {}

class RecommendationLoading extends DetailStateMovie {}

class DetailError extends DetailStateMovie {
  final String message;
  DetailError(this.message);

  @override
  List<Object> get props => [message];
}

class RecommendationError extends DetailStateMovie {
  final String message;
  RecommendationError(this.message);

  @override
  List<Object> get props => [message];
}

class DetailHasData extends DetailStateMovie {
  final MovieDetail detail;
  final List<Movie> recommendationMovies;
  final bool isAddedtoWatchlist;

  DetailHasData(
      this.detail, this.recommendationMovies, this.isAddedtoWatchlist);

  @override
  List<Object> get props => [detail, recommendationMovies, isAddedtoWatchlist];
}

class RecommendationHasData extends DetailStateMovie {
  final List<Movie> movies;

  RecommendationHasData(this.movies);

  @override
  List<Object> get props => [movies];
}

class DetailHasStatus extends DetailStateMovie {
  final bool isAddedtoWatchlist;

  DetailHasStatus(this.isAddedtoWatchlist);

  @override
  List<Object> get props => [isAddedtoWatchlist];
}

class DetailHasMessage extends DetailStateMovie {
  final String message;
  DetailHasMessage(this.message);

  @override
  List<Object> get props => [message];
}
