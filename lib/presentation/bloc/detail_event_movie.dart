part of 'detail_bloc_movie.dart';

abstract class DetailEventMovie extends Equatable {
  const DetailEventMovie();

  @override
  List<Object> get props => [];
}

class GetDetailMovie extends DetailEventMovie {
  final int id;

  GetDetailMovie(this.id);

  @override
  List<Object> get props => [id];
}

class AddWatchlist extends DetailEventMovie {
  final MovieDetail movie;

  AddWatchlist(this.movie);

  @override
  List<Object> get props => [movie];
}

class RemoveFromWatchlist extends DetailEventMovie {
  final MovieDetail movie;

  RemoveFromWatchlist(this.movie);

  @override
  List<Object> get props => [movie];
}

class LoadWatchlistStatus extends DetailEventMovie {
  final int id;

  LoadWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}