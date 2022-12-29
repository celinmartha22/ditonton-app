import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_watchlist_movies.dart';

part 'watchlist_event_movie.dart';
part 'watchlist_state_movie.dart';

class WatchlistBlocMovie
    extends Bloc<WatchlistEventMovie, WatchlistStateMovie> {
  final GetWatchlistMovies getWatchlistMovies;
  var _watchlistMovies = <Movie>[];
  List<Movie> get watchlistMovies => _watchlistMovies;

  WatchlistStateMovie _watchlistState = WatchlistEmpty();
  WatchlistStateMovie get watchlistState => _watchlistState;

  String _message = '';
  String get message => _message;

  WatchlistBlocMovie(this.getWatchlistMovies) : super(WatchlistEmpty()) {
    on<GetWatchlistMovie>((event, emit) async {
      _watchlistState = WatchlistLoading();
      emit(WatchlistLoading());
      final result = await getWatchlistMovies.execute();
      result.fold(
        (failure) {
          _watchlistState = WatchlistError(failure.message);
          _message = failure.message;
          emit(WatchlistError(failure.message));
        },
        (data) {
          _watchlistState = WatchlistHasData(data);
          _watchlistMovies = data;
          emit(WatchlistHasData(data));
        },
      );
    });
  }
}
