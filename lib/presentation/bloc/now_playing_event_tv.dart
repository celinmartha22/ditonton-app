part of 'now_playing_bloc_tv.dart';

abstract class NowPlayingEventTv extends Equatable {
  const NowPlayingEventTv();

  @override
  List<Object> get props => [];
}

class GetNowPlayingTv extends NowPlayingEventTv {}