import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/get_movie_detail.dart';

part 'detail_event_movie.dart';
part 'detail_state_movie.dart';

class DetailBlocMovie extends Bloc<DetailEventMovie, DetailStateMovie> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetMovieDetail getDetailMovies;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  late MovieDetail _movie;
  MovieDetail get movie => _movie;

  DetailStateMovie _movieState = DetailEmpty();
  DetailStateMovie get movieState => _movieState;

  List<Movie> _movieRecommendations = [];
  List<Movie> get movieRecommendations => _movieRecommendations;

  DetailStateMovie _recommendationState = RecommendationEmpty();
  DetailStateMovie get recommendationState => _recommendationState;

  String _message = '';
  String get message => _message;

  bool _isAddedtoWatchlist = false;
  bool get isAddedToWatchlist => _isAddedtoWatchlist;

  DetailBlocMovie(
    this.getDetailMovies,
    this.getMovieRecommendations,
    this.getWatchListStatus,
    this.saveWatchlist,
    this.removeWatchlist,
  ) : super(DetailEmpty()) {
    on<GetDetailMovie>((event, emit) async {
      final id = event.id;
      List<Movie> recommendationMovies = [];
      _movieState = DetailLoading();
      emit(DetailLoading());
      final detailResult = await getDetailMovies.execute(id);
      final recommendationResult = await getMovieRecommendations.execute(id);
      final statusWatchList = await getWatchListStatus.execute(id);
      detailResult.fold(
        (failure) {
          _movieState = DetailError(failure.message);
          _message = failure.message;
          emit(DetailError(failure.message));
        },
        (movie) {
          _recommendationState = RecommendationLoading();
          _movie = movie;
          emit(RecommendationLoading());
          recommendationResult.fold(
            (failure) {
              _recommendationState = RecommendationError(failure.message);
              _message = failure.message;
              emit(RecommendationError(failure.message));
            },
            (movies) {
              _recommendationState = RecommendationHasData(movies);
              _movieRecommendations = movies;
              emit(RecommendationHasData(movies));
              recommendationMovies = movies;
            },
          );
          _movieState =
              DetailHasData(movie, recommendationMovies, statusWatchList);
          emit(DetailHasData(movie, recommendationMovies, statusWatchList));
        },
      );
    });

    on<AddWatchlist>((event, emit) async {
      final movie = event.movie;
      emit(DetailLoading());
      final result = await saveWatchlist.execute(movie);
      result.fold(
        (failure) {
          emit(DetailError(failure.message));
          _watchlistMessage = failure.message;
        },
        (successMessage) {
          emit(DetailHasMessage(successMessage));
          _watchlistMessage = successMessage;
        },
      );
      add(LoadWatchlistStatus(movie.id));
    });

    on<RemoveFromWatchlist>((event, emit) async {
      final movie = event.movie;
      emit(DetailLoading());
      final result = await removeWatchlist.execute(movie);
      result.fold(
        (failure) {
          emit(DetailError(failure.message));
          _watchlistMessage = failure.message;
        },
        (successMessage) {
          emit(DetailHasMessage(successMessage));
          _watchlistMessage = successMessage;
        },
      );
      add(LoadWatchlistStatus(movie.id));
    });

    on<LoadWatchlistStatus>((event, emit) async {
      final id = event.id;
      emit(DetailLoading());
      final result = await getWatchListStatus.execute(id);
      _isAddedtoWatchlist = result;
      emit(DetailHasStatus(result));
    });
  }
}
