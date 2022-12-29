import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_movie_recommendations.dart';

part 'recommendations_event_movie.dart';
part 'recommendations_state_movie.dart';

class RecommendationsBlocMovie
    extends Bloc<RecommendationsEventMovie, RecommendationsStateMovie> {
  final GetMovieRecommendations getRecommendationsMovies;

  RecommendationsBlocMovie(this.getRecommendationsMovies) : super(RecommendationsEmpty()) {
    on<GetRecommendationsMovie>((event, emit) async {
      final id = event.id;
      emit(RecommendationsLoading());
      final result = await getRecommendationsMovies.execute(id);
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
