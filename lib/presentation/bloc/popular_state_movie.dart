part of 'popular_bloc_movie.dart';

abstract class PopularStateMovie extends Equatable {
 const PopularStateMovie();
  @override
  List<Object> get props => [];
}

class PopularEmpty extends PopularStateMovie {
  
}

class PopularLoading extends PopularStateMovie {
  
}
class PopularError extends PopularStateMovie {
  final String message;
  PopularError(this.message);

  @override
  List<Object> get props => [message];
}

class PopularHasData extends PopularStateMovie {
  final List<Movie> result;

  PopularHasData(this.result);

  @override
  List<Object> get props => [result];
}