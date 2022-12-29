import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_top_rated_movies.dart';

part 'top_rated_event_movie.dart';
part 'top_rated_state_movie.dart';

class TopRatedBlocMovie extends Bloc<TopRatedEventMovie, TopRatedStateMovie> {
  final GetTopRatedMovies getTopRatedMovies;

  TopRatedStateMovie _state = TopRatedEmpty();
  TopRatedStateMovie get topRatedState => _state;

  List<Movie> _movies = [];
  List<Movie> get movies => _movies;

  String _message = '';
  String get message => _message;

  TopRatedBlocMovie(this.getTopRatedMovies) : super(TopRatedEmpty()) {
    on<GetTopRatedMovie>((event, emit) async {
      _state = TopRatedLoading();
      emit(TopRatedLoading());
      final result = await getTopRatedMovies.execute();
      result.fold(
        (failure) {
          _message = failure.message;
          _state = TopRatedError(failure.message);
          emit(TopRatedError(failure.message));
        },
        (data) {
          _movies = data;
          _state = TopRatedHasData(data);
          emit(TopRatedHasData(data));
        },
      );
    });
  }
}
