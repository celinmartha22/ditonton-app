import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/tv.dart';
import '../../domain/usecases/get_now_playing_tv_series.dart';

part 'now_playing_event_tv.dart';
part 'now_playing_state_tv.dart';

class NowPlayingBlocTv extends Bloc<NowPlayingEventTv, NowPlayingStateTv> {
  final GetNowPlayingTvSeries getNowPlayingTvSeries;
  NowPlayingStateTv _state = NowPlayingEmpty();
  NowPlayingStateTv get nowPlayingTvState => _state;

  List<Tv> _tvSeries = [];
  List<Tv> get tvSeries => _tvSeries;

  String _message = '';
  String get message => _message;

  NowPlayingBlocTv(this.getNowPlayingTvSeries) : super(NowPlayingEmpty()) {
    on<GetNowPlayingTv>((event, emit) async {
      _state = NowPlayingLoading();
      emit(NowPlayingLoading());
      final result = await getNowPlayingTvSeries.execute();
      result.fold(
        (failure) {
          _message = failure.message;
          _state = NowPlayingError(failure.message);
          emit(NowPlayingError(failure.message));
        },
        (data) {
          _tvSeries = data;
          _state = NowPlayingHasData(data);
          emit(NowPlayingHasData(data));
        },
      );
    });
  }
}
