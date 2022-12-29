import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/tv.dart';
import '../../domain/usecases/get_watchlist_tv_series.dart';

part 'watchlist_event_tv.dart';
part 'watchlist_state_tv.dart';

class WatchlistBlocTv extends Bloc<WatchlistEventTv, WatchlistStateTv> {
  final GetWatchlistTvSeries getWatchlistTvSeries;

  var _watchlistTvSeries = <Tv>[];
  List<Tv> get watchlistTvSeries => _watchlistTvSeries;

  WatchlistStateTv _watchlistState = WatchlistEmpty();
  WatchlistStateTv get watchlistState => _watchlistState;

  String _message = '';
  String get message => _message;

  WatchlistBlocTv(this.getWatchlistTvSeries) : super(WatchlistEmpty()) {
    on<GetWatchlistTv>((event, emit) async {
      _watchlistState = WatchlistLoading();
      emit(WatchlistLoading());
      final result = await getWatchlistTvSeries.execute();
      result.fold(
        (failure) {
          _watchlistState = WatchlistError(failure.message);
          _message = failure.message;
          emit(WatchlistError(failure.message));
        },
        (data) {
          _watchlistState = WatchlistHasData(data);
          _watchlistTvSeries = data;
          emit(WatchlistHasData(data));
        },
      );
    });
  }
}
