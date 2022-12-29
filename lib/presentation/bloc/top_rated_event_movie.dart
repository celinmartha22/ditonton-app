part of 'top_rated_bloc_movie.dart';

abstract class TopRatedEventMovie extends Equatable {
  const TopRatedEventMovie();

  @override
  List<Object> get props => [];
}

class GetTopRatedMovie extends TopRatedEventMovie {}