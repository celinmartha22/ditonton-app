part of 'watchlist_bloc_tv.dart';

abstract class WatchlistStateTv extends Equatable {
 const WatchlistStateTv();
  @override
  List<Object> get props => [];
}

class WatchlistEmpty extends WatchlistStateTv {
  
}

class WatchlistLoading extends WatchlistStateTv {
  
}
class WatchlistError extends WatchlistStateTv {
  final String message;
  WatchlistError(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistHasData extends WatchlistStateTv {
  final List<Tv> result;

  WatchlistHasData(this.result);

  @override
  List<Object> get props => [result];
}