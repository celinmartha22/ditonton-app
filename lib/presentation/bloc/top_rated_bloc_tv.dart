import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/tv.dart';
import '../../domain/usecases/get_top_rated_tv_series.dart';

part 'top_rated_event_tv.dart';
part 'top_rated_state_tv.dart';

class TopRatedBlocTv extends Bloc<TopRatedEventTv, TopRatedStateTv> {
  final GetTopRatedTvSeries getTopRatedTvSeries;

  TopRatedStateTv _state = TopRatedEmpty();
  TopRatedStateTv get topRatedTvState => _state;

  List<Tv> _tvSeries = [];
  List<Tv> get tvSeries => _tvSeries;

  String _message = '';
  String get message => _message;

  TopRatedBlocTv(this.getTopRatedTvSeries) : super(TopRatedEmpty()) {
    on<GetTopRatedTv>((event, emit) async {
      _state = TopRatedLoading();
      emit(TopRatedLoading());
      final result = await getTopRatedTvSeries.execute();
      result.fold(
        (failure) {
          _message = failure.message;
          _state = TopRatedError(failure.message);
          emit(TopRatedError(failure.message));
        },
        (data) {
          _tvSeries = data;
          _state = TopRatedHasData(data);
          emit(TopRatedHasData(data));
        },
      );
    });
  }
}
