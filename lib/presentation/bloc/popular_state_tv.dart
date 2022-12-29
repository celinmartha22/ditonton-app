part of 'popular_bloc_tv.dart';

abstract class PopularStateTv extends Equatable {
 const PopularStateTv();
  @override
  List<Object> get props => [];
}

class PopularEmpty extends PopularStateTv {
  
}

class PopularLoading extends PopularStateTv {
  
}
class PopularError extends PopularStateTv {
  final String message;
  PopularError(this.message);

  @override
  List<Object> get props => [message];
}

class PopularHasData extends PopularStateTv {
  final List<Tv> result;

  PopularHasData(this.result);

  @override
  List<Object> get props => [result];
}