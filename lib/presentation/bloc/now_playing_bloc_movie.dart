import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_now_playing_movies.dart';

part 'now_playing_event_movie.dart';
part 'now_playing_state_movie.dart';

class NowPlayingBlocMovie
    extends Bloc<NowPlayingEventMovie, NowPlayingStateMovie> {
  final GetNowPlayingMovies getNowPlayingMovies;
  NowPlayingStateMovie _state = NowPlayingEmpty();
  NowPlayingStateMovie get nowPlayingState => _state;

  List<Movie> _movies = [];
  List<Movie> get movies => _movies;

  String _message = '';
  String get message => _message;

  NowPlayingBlocMovie(this.getNowPlayingMovies) : super(NowPlayingEmpty()) {
    on<GetNowPlayingMovie>((event, emit) async {
      _state = NowPlayingLoading();
      emit(NowPlayingLoading());
      final result = await getNowPlayingMovies.execute();
      result.fold(
        (failure) {
          _message = failure.message;
          _state = NowPlayingError(failure.message);
          emit(NowPlayingError(failure.message));
        },
        (data) {
          _movies = data;
          _state = NowPlayingHasData(data);
          emit(NowPlayingHasData(data));
        },
      );
    });
  }
}
