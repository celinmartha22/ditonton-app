import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

part 'search_event_tv.dart';
part 'search_state_tv.dart';

class SearchBlocTv extends Bloc<SearchEventTv, SearchStateTv> {
  final SearchTvSeries _searchTvSeries;

  SearchStateTv _state = SearchEmpty();
  SearchStateTv get searchTvState => _state;

  List<Tv> _searchResult = [];
  List<Tv> get searchResult => _searchResult;

  String _message = '';
  String get message => _message;

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  SearchBlocTv(this._searchTvSeries) : super(SearchEmpty()) {
    on<OnQueryChanged>((event, emit) async {
      final query = event.query;
      print(query);
      _state = SearchLoading();
      emit(SearchLoading());
      final result = await _searchTvSeries.execute(query);

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
