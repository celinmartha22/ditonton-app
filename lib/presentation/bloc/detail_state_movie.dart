part of 'detail_bloc_movie.dart';

class DetailStateMovie extends Equatable {
  final MovieDetail? movieDetail;
  final RequestState detailStateMovie;
  final List<Movie> movieRecommendations;
  final RequestState movieRecommendationsState;
  final bool isAddedToWatchlist;
  final String message;
  final String watchlistMessage;

  const DetailStateMovie({
    required this.movieDetail,
    required this.detailStateMovie,
    required this.movieRecommendations,
    required this.movieRecommendationsState,
    required this.isAddedToWatchlist,
    required this.message,
    required this.watchlistMessage,
  });
  DetailStateMovie copyWith({
    MovieDetail? movieDetail,
    RequestState? detailStateMovie,
    List<Movie>? movieRecommendations,
    RequestState? movieRecommendationsState,
    bool? isAddedToWatchlist,
    String? message,
    String? watchlistMessage,
  }) {
    return DetailStateMovie(
      movieDetail: movieDetail ?? this.movieDetail,
      detailStateMovie: detailStateMovie ?? this.detailStateMovie,
      movieRecommendations: movieRecommendations ?? this.movieRecommendations,
      movieRecommendationsState:
          movieRecommendationsState ?? this.movieRecommendationsState,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      message: message ?? this.message,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  factory DetailStateMovie.initial() => DetailStateMovie(
      movieDetail: MovieDetail(
          adult: false,
          backdropPath: 'backdropPath',
          genres: <Genre>[],
          id: 1,
          originalTitle: 'originalTitle',
          overview: 'overview',
          posterPath: 'posterPath',
          releaseDate: 'releaseDate',
          runtime: 1,
          title: 'title',
          voteAverage: 1,
          voteCount: 1),
      detailStateMovie: RequestState.Empty,
      movieRecommendations: <Movie>[],
      movieRecommendationsState: RequestState.Empty,
      isAddedToWatchlist: false,
      message: '',
      watchlistMessage: '');

  @override
  List<Object?> get props => [
        movieDetail,
        detailStateMovie,
        movieRecommendations,
        movieRecommendationsState,
        isAddedToWatchlist,
        message,
        watchlistMessage
      ];
}
