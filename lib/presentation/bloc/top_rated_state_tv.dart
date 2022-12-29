part of 'top_rated_bloc_tv.dart';

abstract class TopRatedStateTv extends Equatable {
 const TopRatedStateTv();
  @override
  List<Object> get props => [];
}

class TopRatedEmpty extends TopRatedStateTv {
  
}

class TopRatedLoading extends TopRatedStateTv {
  
}
class TopRatedError extends TopRatedStateTv {
  final String message;
  TopRatedError(this.message);

  @override
  List<Object> get props => [message];
}

class TopRatedHasData extends TopRatedStateTv {
  final List<Tv> result;

  TopRatedHasData(this.result);

  @override
  List<Object> get props => [result];
}