import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/movie.dart';
import 'package:rxdart/rxdart.dart';

part 'search_event_movie.dart';
part 'search_state_movie.dart';

class SearchBlocMovie extends Bloc<SearchEventMovie, SearchStateMovie> {
  final SearchMovies _searchMovies;

  SearchStateMovie _state = SearchEmpty();
  SearchStateMovie get searchState => _state;

  List<Movie> _searchResult = [];
  List<Movie> get searchResult => _searchResult;

  String _message = '';
  String get message => _message;

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  SearchBlocMovie(this._searchMovies) : super(SearchEmpty()) {
    on<OnQueryChanged>((event, emit) async {
      final query = event.query;
      _state = SearchLoading();
      emit(SearchLoading());
      final result = await _searchMovies.execute(query);

      result.fold(
        (failure) {
          _message = failure.message;
          _state = SearchError(failure.message);
          emit(SearchError(failure.message));
        },
        (data) {
          _searchResult = data;
          _state = SearchHasData(data);
          emit(SearchHasData(data));
        },
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }
}
