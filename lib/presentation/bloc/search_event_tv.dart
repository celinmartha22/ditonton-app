part of 'search_bloc_tv.dart';

abstract class SearchEventTv extends Equatable {
  const SearchEventTv();

  @override
  List<Object> get props => [];
}

class OnQueryChanged extends SearchEventTv {
  final String query;

  OnQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}
