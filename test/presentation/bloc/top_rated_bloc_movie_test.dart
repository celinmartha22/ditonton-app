import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/presentation/bloc/top_rated_bloc_movie.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// import '../provider/movie_top_rated_notifier_test.mocks.dart';
import 'top_rated_bloc_movie_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
void main() {
  late TopRatedBlocMovie topRatedBlocMovie;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(
    () {
      mockGetTopRatedMovies = MockGetTopRatedMovies();
      topRatedBlocMovie = TopRatedBlocMovie(mockGetTopRatedMovies);
    },
  );

  test(
    'initial state should be empty',
    () {
      expect(topRatedBlocMovie.state, TopRatedEmpty());
    },
  );

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );

  final tMovieList = <Movie>[tMovie];

  blocTest<TopRatedBlocMovie, TopRatedStateMovie>(
    'Should emit [Loading, HasData] when data is gotten succesfully',
    build: () {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return topRatedBlocMovie;
    },
    act: (bloc) => bloc.add(GetTopRatedMovie()),
    wait: const Duration(microseconds: 100),
    expect: () => [
      TopRatedLoading(),
      TopRatedHasData(tMovieList),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedMovies.execute());
    },
  );

  blocTest<TopRatedBlocMovie, TopRatedStateMovie>(
    'Should emit [Loading, Error] when get TopRated is unsuccessful',
    build: () {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => left(ServerFailure('Server Failure.')));
      return topRatedBlocMovie;
    },
    act: (bloc) => bloc.add(GetTopRatedMovie()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TopRatedLoading(),
      TopRatedError('Server Failure.'),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedMovies.execute());
    },
  );
}
