part of 'detail_bloc_tv.dart';

abstract class DetailStateTv extends Equatable {
  const DetailStateTv();
  @override
  List<Object> get props => [];
}

class DetailEmpty extends DetailStateTv {}

class RecommendationEmpty extends DetailStateTv {}

class DetailLoading extends DetailStateTv {}

class RecommendationLoading extends DetailStateTv {}

class DetailError extends DetailStateTv {
  final String message;
  DetailError(this.message);

  @override
  List<Object> get props => [message];
}

class RecommendationError extends DetailStateTv {
  final String message;
  RecommendationError(this.message);

  @override
  List<Object> get props => [message];
}

class DetailHasData extends DetailStateTv {
  final TvDetail detail;
  final List<Tv> recommendationTvSeries;
  final bool isAddedtoWatchlist;

  DetailHasData(
      this.detail, this.recommendationTvSeries, this.isAddedtoWatchlist);

  @override
  List<Object> get props => [detail, recommendationTvSeries, isAddedtoWatchlist];
}

class RecommendationHasData extends DetailStateTv {
  final List<Tv> tvSeries;

  RecommendationHasData(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

class DetailHasStatus extends DetailStateTv {
  final bool isAddedtoWatchlist;

  DetailHasStatus(this.isAddedtoWatchlist);

  @override
  List<Object> get props => [isAddedtoWatchlist];
}

class DetailHasMessage extends DetailStateTv {
  final String message;
  DetailHasMessage(this.message);

  @override
  List<Object> get props => [message];
}
