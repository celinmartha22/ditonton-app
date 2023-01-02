part of 'detail_bloc_tv.dart';

class DetailStateTv extends Equatable {
  final TvDetail? tvDetail;
  final RequestState detailStateTv;
  final List<Tv> tvRecommendations;
  final RequestState tvRecommendationsState;
  final bool isAddedToWatchlist;
  final String message;
  final String watchlistMessage;
  DetailStateTv({
    required this.tvDetail,
    required this.detailStateTv,
    required this.tvRecommendations,
    required this.tvRecommendationsState,
    required this.isAddedToWatchlist,
    required this.message,
    required this.watchlistMessage,
  });
  DetailStateTv copyWith({
    TvDetail? tvDetail,
    RequestState? detailStateTv,
    List<Tv>? tvRecommendations,
    RequestState? tvRecommendationsState,
    bool? isAddedToWatchlist,
    String? message,
    String? watchlistMessage,
  }) {
    return DetailStateTv(
      tvDetail: tvDetail ?? this.tvDetail,
      detailStateTv: detailStateTv ?? this.detailStateTv,
      tvRecommendations: tvRecommendations ?? this.tvRecommendations,
      tvRecommendationsState:
          tvRecommendationsState ?? this.tvRecommendationsState,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      message: message ?? this.message,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  factory DetailStateTv.initial() => DetailStateTv(
      tvDetail: TvDetail(
          backdropPath: 'backdropPath',
          firstAirDate: 'firstAirDate',
          genres: <Genre>[],
          id: 1,
          name: 'name',
          originCountry: <String>[],
          originalLanguage: 'originalLanguage',
          originalName: 'originalName',
          overview: 'overview',
          popularity: 1,
          posterPath: 'posterPath',
          seasons: <Season>[],
          voteAverage: 1,
          voteCount: 1),
      detailStateTv: RequestState.Empty,
      tvRecommendations: <Tv>[],
      tvRecommendationsState: RequestState.Empty,
      isAddedToWatchlist: false,
      message: '',
      watchlistMessage: '');

  @override
  List<Object?> get props => [
    tvDetail,
    detailStateTv,
    tvRecommendations,
    tvRecommendationsState,
    isAddedToWatchlist,
    message,
    watchlistMessage
  ];
}
