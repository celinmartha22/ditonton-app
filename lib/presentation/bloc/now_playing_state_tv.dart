part of 'now_playing_bloc_tv.dart';

abstract class NowPlayingStateTv extends Equatable {
 const NowPlayingStateTv();
  @override
  List<Object> get props => [];
}

class NowPlayingEmpty extends NowPlayingStateTv {
  
}

class NowPlayingLoading extends NowPlayingStateTv {
  
}
class NowPlayingError extends NowPlayingStateTv {
  final String message;
  NowPlayingError(this.message);

  @override
  List<Object> get props => [message];
}

class NowPlayingHasData extends NowPlayingStateTv {
  final List<Tv> result;

  NowPlayingHasData(this.result);

  @override
  List<Object> get props => [result];
}