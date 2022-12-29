part of 'now_playing_bloc_movie.dart';

abstract class NowPlayingStateMovie extends Equatable {
 const NowPlayingStateMovie();
  @override
  List<Object> get props => [];
}

class NowPlayingEmpty extends NowPlayingStateMovie {
  
}

class NowPlayingLoading extends NowPlayingStateMovie {
  
}
class NowPlayingError extends NowPlayingStateMovie {
  final String message;
  NowPlayingError(this.message);

  @override
  List<Object> get props => [message];
}

class NowPlayingHasData extends NowPlayingStateMovie {
  final List<Movie> result;

  NowPlayingHasData(this.result);

  @override
  List<Object> get props => [result];
}