part of 'top_rated_bloc_movie.dart';

abstract class TopRatedStateMovie extends Equatable {
 const TopRatedStateMovie();
  @override
  List<Object> get props => [];
}

class TopRatedEmpty extends TopRatedStateMovie {
  
}

class TopRatedLoading extends TopRatedStateMovie {
  
}
class TopRatedError extends TopRatedStateMovie {
  final String message;
  TopRatedError(this.message);

  @override
  List<Object> get props => [message];
}

class TopRatedHasData extends TopRatedStateMovie {
  final List<Movie> result;

  TopRatedHasData(this.result);

  @override
  List<Object> get props => [result];
}