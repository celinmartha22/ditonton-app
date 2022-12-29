import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/tv.dart';
import '../../domain/usecases/get_tv_recommendations.dart';

part 'recommendations_event_tv.dart';
part 'recommendations_state_tv.dart';

class RecommendationsBlocTv
    extends Bloc<RecommendationsEventTv, RecommendationsStateTv> {
  final GetTvRecommendations getRecommendationsTvSeries;

  RecommendationsBlocTv(this.getRecommendationsTvSeries) : super(RecommendationsEmpty()) {
    on<GetRecommendationsTv>((event, emit) async {
      final id = event.id;
      emit(RecommendationsLoading());
      final result = await getRecommendationsTvSeries.execute(id);
      result.fold(
        (failure) {
          emit(RecommendationsError(failure.message));
        },
        (data) {
          emit(RecommendationsHasData(data));
        },
      );
    });
  }
}
