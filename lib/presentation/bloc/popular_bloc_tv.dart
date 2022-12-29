import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/tv.dart';
import '../../domain/usecases/get_popular_tv_series.dart';

part 'popular_event_tv.dart';
part 'popular_state_tv.dart';

class PopularBlocTv extends Bloc<PopularEventTv, PopularStateTv> {
  final GetPopularTvSeries getPopularTvSeries;

  PopularStateTv _state = PopularEmpty();
  PopularStateTv get popularTvState => _state;

  List<Tv> _tvSeries = [];
  List<Tv> get tvSeries => _tvSeries;

  String _message = '';
  String get message => _message;

  PopularBlocTv(this.getPopularTvSeries) : super(PopularEmpty()) {
    on<GetPopularTv>((event, emit) async {
      _state = PopularLoading();
      emit(PopularLoading());
      final result = await getPopularTvSeries.execute();
      result.fold(
        (failure) {
          _message = failure.message;
          _state = PopularError(failure.message);
          emit(PopularError(failure.message));
        },
        (data) {
          _tvSeries = data;
          _state = PopularHasData(data);
          emit(PopularHasData(data));
        },
      );
    });
  }
}
