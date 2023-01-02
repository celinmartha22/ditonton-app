import 'package:bloc/bloc.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_tv.dart';
import 'package:ditonton/domain/usecases/remove_tv_watchlist.dart';
import 'package:ditonton/domain/usecases/save_tv_watchlist.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/get_tv_detail.dart';

part 'detail_event_tv.dart';
part 'detail_state_tv.dart';

class DetailBlocTv extends Bloc<DetailEventTv, DetailStateTv> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvDetail getTvDetail;
  final GetTvRecommendations getTvRecommendations;
  final GetWatchListStatusTv getWatchListStatus;
  final SaveTvWatchlist saveWatchlist;
  final RemoveTvWatchlist removeWatchlist;

  DetailBlocTv({
    required this.getTvDetail,
    required this.getTvRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(DetailStateTv.initial()) {
    on<GetDetailTv>(_onGetDetailTv);
    on<LoadWatchlistStatus>(_onLoadWatchlistStatus);
    on<AddWatchlist>(_onAddWatchlist);
    on<RemoveFromWatchlist>(_onRemoveFromWatchlist);
  }

  void _onGetDetailTv(
    GetDetailTv event,
    Emitter<DetailStateTv> emit,
  ) async {
    emit(state.copyWith(detailStateTv: RequestState.Loading));

    final detailResult = await getTvDetail.execute(event.id);
    final recommendationResult = await getTvRecommendations.execute(event.id);
    final resultStatus = await getWatchListStatus.execute(event.id);

    detailResult.fold(
      (failure) {
        if (failure is ServerFailure) {
          emit(
            state.copyWith(
              detailStateTv: RequestState.Error,
              message: failure.message,
            ),
          );
        } else if (failure is ConnectionFailure) {
          emit(
            state.copyWith(
              detailStateTv: RequestState.Error,
              message: failure.message,
            ),
          );
        }
      },
      (tvSeriesData) async {
        emit(
          state.copyWith(
            detailStateTv: RequestState.Loaded,
            tvDetail: tvSeriesData,
          ),
        );

        recommendationResult.fold(
          (failure) {
            if (failure is ServerFailure) {
              emit(
                state.copyWith(
                  tvRecommendationsState: RequestState.Error,
                  message: failure.message,
                ),
              );
            } else if (failure is ConnectionFailure) {
              emit(
                state.copyWith(
                  tvRecommendationsState: RequestState.Error,
                  message: failure.message,
                ),
              );
            }
          },
          (tvSeriesData) {
            emit(
              state.copyWith(
                tvRecommendationsState: RequestState.Loaded,
                tvRecommendations: tvSeriesData,
              ),
            );
          },
        );
      },
    );
  }

  void _onAddWatchlist(
    AddWatchlist event,
    Emitter<DetailStateTv> emit,
  ) async {
    final result = await saveWatchlist.execute(event.tv);
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
        event.tv.id,
      ),
    );
  }

  void _onRemoveFromWatchlist(
    RemoveFromWatchlist event,
    Emitter<DetailStateTv> emit,
  ) async {
    final result = await removeWatchlist.execute(event.tv);
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
        event.tv.id,
      ),
    );
  }

  void _onLoadWatchlistStatus(
    LoadWatchlistStatus event,
    Emitter<DetailStateTv> emit,
  ) async {
    final resultStatus = await getWatchListStatus.execute(event.id);

    emit(
      state.copyWith(
        isAddedToWatchlist: resultStatus,
      ),
    );
  }
}
