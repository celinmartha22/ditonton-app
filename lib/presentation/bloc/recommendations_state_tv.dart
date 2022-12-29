part of 'recommendations_bloc_tv.dart';

abstract class RecommendationsStateTv extends Equatable {
 const RecommendationsStateTv();
  @override
  List<Object> get props => [];
}

class RecommendationsEmpty extends RecommendationsStateTv {
  
}

class RecommendationsLoading extends RecommendationsStateTv {
  
}
class RecommendationsError extends RecommendationsStateTv {
  final String message;
  RecommendationsError(this.message);

  @override
  List<Object> get props => [message];
}

class RecommendationsHasData extends RecommendationsStateTv {
  final List<Tv> result;

  RecommendationsHasData(this.result);

  @override
  List<Object> get props => [result];
}