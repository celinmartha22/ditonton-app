part of 'popular_bloc_movie.dart';

abstract class PopularEventMovie extends Equatable {
  const PopularEventMovie();

  @override
  List<Object> get props => [];
}

class GetPopularMovie extends PopularEventMovie {}