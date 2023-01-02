import 'package:bloc/bloc.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:equatable/equatable.dart';
import '../../common/state_enum.dart';
import '../../domain/usecases/get_movie_detail.dart';

part 'detail_event_movie.dart';
part 'detail_state_movie.dart';

class DetailBlocMovie extends Bloc<DetailEventMovie, DetailStateMovie> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  DetailBlocMovie({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(DetailStateMovie.initial()) {
    on<GetDetailMovie>(_onGetDetailMovie);
    on<LoadWatchlistStatus>(_onLoadWatchlistStatus);
    on<AddWatchlist>(_onAddWatchlist);
    on<RemoveFromWatchlist>(_onRemoveFromWatchlist);
  }

  void _onGetDetailMovie(
    GetDetailMovie event,
    Emitter<DetailStateMovie> emit,
  ) async {
    emit(state.copyWith(detailStateMovie: RequestState.Loading));

    final detailResult = await getMovieDetail.execute(event.id);

    final recommendationResult =
        await getMovieRecommendations.execute(event.id);

    detailResult.fold(
      (failure) {
        if (failure is ServerFailure) {
          emit(
            state.copyWith(
              detailStateMovie: RequestState.Error,
              message: failure.message,
            ),
          );
        } else if (failure is ConnectionFailure) {
          emit(
            state.copyWith(
              detailStateMovie: RequestState.Error,
              message: failure.message,
            ),
          );
        }
      },
      (moviesData) async {
        emit(
          state.copyWith(
            detailStateMovie: RequestState.Loaded,
            movieDetail: moviesData,
          ),
        );

        recommendationResult.fold(
          (failure) {
            if (failure is ServerFailure) {
              emit(
                state.copyWith(
                  movieRecommendationsState: RequestState.Error,
                  message: failure.message,
                ),
              );
            } else if (failure is ConnectionFailure) {
              emit(
                state.copyWith(
                  movieRecommendationsState: RequestState.Error,
                  message: failure.message,
                ),
              );
            }
          },
          (moviesData) {
            emit(
              state.copyWith(
                movieRecommendationsState: RequestState.Loaded,
                movieRecommendations: moviesData,
              ),
            );
          },
        );
      },
    );
  }

  void _onAddWatchlist(
    AddWatchlist event,
    Emitter<DetailStateMovie> emit,
  ) async {
    final result = await saveWatchlist.execute(event.movie);
    result.fold(
      (failure) {
        if (failure is DatabaseFailure) {
          emit(
            state.copyWith(
              watchlistMessage: failure.message,
            ),
          );
        }
      },
      (successMessage) {
        emit(
          state.copyWith(
            watchlistMessage: successMessage,
          ),
        );
      },
    );
    add(
      LoadWatchlistStatus(
        event.movie.id,
      ),
    );
  }

  void _onRemoveFromWatchlist(
    RemoveFromWatchlist event,
    Emitter<DetailStateMovie> emit,
  ) async {
    final result = await removeWatchlist.execute(event.movie);
    result.fold(
      (failure) {
        if (failure is DatabaseFailure) {
          emit(
            state.copyWith(
              watchlistMessage: failure.message,
            ),
          );
        }
      },
      (successMessage) {
        emit(
          state.copyWith(
            watchlistMessage: successMessage,
          ),
        );
      },
    );
    add(
      LoadWatchlistStatus(
        event.movie.id,
      ),
    );
  }

  void _onLoadWatchlistStatus(
    LoadWatchlistStatus event,
    Emitter<DetailStateMovie> emit,
  ) async {
    final resultStatus = await getWatchListStatus.execute(event.id);

    emit(
      state.copyWith(
        isAddedToWatchlist: resultStatus,
      ),
    );
  }
}
