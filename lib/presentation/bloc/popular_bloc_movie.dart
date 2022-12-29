import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_popular_movies.dart';

part 'popular_event_movie.dart';
part 'popular_state_movie.dart';

class PopularBlocMovie extends Bloc<PopularEventMovie, PopularStateMovie> {
  final GetPopularMovies getPopularMovies;

  PopularStateMovie _state = PopularEmpty();
  PopularStateMovie get popularMovieState => _state;

  List<Movie> _movies = [];
  List<Movie> get movies => _movies;

  String _message = '';
  String get message => _message;

  PopularBlocMovie(this.getPopularMovies) : super(PopularEmpty()) {
    on<GetPopularMovie>((event, emit) async {
      _state = PopularLoading();
      emit(PopularLoading());
      final result = await getPopularMovies.execute();
      result.fold(
        (failure) {
          _message = failure.message;
          _state = PopularError(failure.message);
          emit(PopularError(failure.message));
        },
        (data) {
          _movies = data;
          _state = PopularHasData(data);
          emit(PopularHasData(data));
        },
      );
    });
  }
}
