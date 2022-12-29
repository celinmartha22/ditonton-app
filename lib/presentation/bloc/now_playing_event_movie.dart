part of 'now_playing_bloc_movie.dart';

abstract class NowPlayingEventMovie extends Equatable {
  const NowPlayingEventMovie();

  @override
  List<Object> get props => [];
}

class GetNowPlayingMovie extends NowPlayingEventMovie {}