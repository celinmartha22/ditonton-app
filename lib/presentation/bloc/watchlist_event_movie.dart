part of 'watchlist_bloc_movie.dart';

abstract class WatchlistEventMovie extends Equatable {
  const WatchlistEventMovie();

  @override
  List<Object> get props => [];
}

class GetWatchlistMovie extends WatchlistEventMovie {}