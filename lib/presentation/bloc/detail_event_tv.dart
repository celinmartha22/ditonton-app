part of 'detail_bloc_tv.dart';

abstract class DetailEventTv extends Equatable {
  const DetailEventTv();

  @override
  List<Object> get props => [];
}

class GetDetailTv extends DetailEventTv {
  final int id;

  GetDetailTv(this.id);

  @override
  List<Object> get props => [id];
}

class AddWatchlist extends DetailEventTv {
  final TvDetail tv;

  AddWatchlist(this.tv);

  @override
  List<Object> get props => [tv];
}

class RemoveFromWatchlist extends DetailEventTv {
  final TvDetail tv;

  RemoveFromWatchlist(this.tv);

  @override
  List<Object> get props => [tv];
}

class LoadWatchlistStatus extends DetailEventTv {
  final int id;

  LoadWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}