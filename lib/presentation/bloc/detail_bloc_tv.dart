import 'package:bloc/bloc.dart';
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

  final GetTvDetail getDetailTvs;
  final GetTvRecommendations getTvRecommendations;
  final GetWatchListStatusTv getWatchListStatusTv;
  final SaveTvWatchlist saveTvWatchlist;
  final RemoveTvWatchlist removeTvWatchlist;

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  late TvDetail _tv;
  TvDetail get tv => _tv;

  DetailStateTv _tvState = DetailEmpty();
  DetailStateTv get tvState => _tvState;

  List<Tv> _tvRecommendations = [];
  List<Tv> get tvRecommendations => _tvRecommendations;

  DetailStateTv _recommendationState = RecommendationEmpty();
  DetailStateTv get recommendationState => _recommendationState;

  String _message = '';
  String get message => _message;

  bool _isAddedtoWatchlist = false;
  bool get isAddedToWatchlist => _isAddedtoWatchlist;

  DetailBlocTv(
    this.getDetailTvs,
    this.getTvRecommendations,
    this.getWatchListStatusTv,
    this.saveTvWatchlist,
    this.removeTvWatchlist,
  ) : super(DetailEmpty()) {
    on<GetDetailTv>((event, emit) async {
      final id = event.id;
      List<Tv> recommendationTvSeries = [];
      _tvState = DetailLoading();
      emit(DetailLoading());
      final detailResult = await getDetailTvs.execute(id);
      final recommendationResult = await getTvRecommendations.execute(id);
      final statusWatchList = await getWatchListStatusTv.execute(id);
      detailResult.fold(
        (failure) {
          _tvState = DetailError(failure.message);
          _message = failure.message;
          emit(DetailError(failure.message));
        },
        (tv) {
          _recommendationState = RecommendationLoading();
          _tv = tv;
          emit(RecommendationLoading());
          recommendationResult.fold(
            (failure) {
              _recommendationState = RecommendationError(failure.message);
              _message = failure.message;
              emit(RecommendationError(failure.message));
            },
            (tvSeries) {
              _recommendationState = RecommendationHasData(tvSeries);
              _tvRecommendations = tvSeries;
              emit(RecommendationHasData(tvSeries));
              recommendationTvSeries = tvSeries;
            },
          );
          _tvState = DetailHasData(tv, recommendationTvSeries, statusWatchList);
          emit(DetailHasData(tv, recommendationTvSeries, statusWatchList));
        },
      );
    });

    on<AddWatchlist>((event, emit) async {
      final tv = event.tv;
      emit(DetailLoading());
      final result = await saveTvWatchlist.execute(tv);
      result.fold(
        (failure) {
          _watchlistMessage = failure.message;
          emit(DetailError(failure.message));
        },
        (successMessage) {
          _watchlistMessage = successMessage;
          emit(DetailHasMessage(successMessage));
        },
      );
      add(LoadWatchlistStatus(tv.id));
    });

    on<RemoveFromWatchlist>((event, emit) async {
      final tv = event.tv;
      emit(DetailLoading());
      final result = await removeTvWatchlist.execute(tv);
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
      add(LoadWatchlistStatus(tv.id));
    });

    on<LoadWatchlistStatus>((event, emit) async {
      final id = event.id;
      emit(DetailLoading());
      final result = await getWatchListStatusTv.execute(id);
      _isAddedtoWatchlist = result;
      emit(DetailHasStatus(result));
    });
  }
}
