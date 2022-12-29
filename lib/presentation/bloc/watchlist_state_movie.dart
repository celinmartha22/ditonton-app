part of 'watchlist_bloc_movie.dart';

abstract class WatchlistStateMovie extends Equatable {
 const WatchlistStateMovie();
  @override
  List<Object> get props => [];
}

class WatchlistEmpty extends WatchlistStateMovie {
  
}

class WatchlistLoading extends WatchlistStateMovie {
  
}
class WatchlistError extends WatchlistStateMovie {
  final String message;
  WatchlistError(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistHasData extends WatchlistStateMovie {
  final List<Movie> result;

  WatchlistHasData(this.result);

  @override
  List<Object> get props => [result];
}