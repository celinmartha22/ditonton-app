import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/presentation/bloc/popular_bloc_movie.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// import '../provider/movie_popular_notifier_test.mocks.dart';
import 'popular_bloc_movie_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main() {
  late PopularBlocMovie popularBlocMovie;
  late MockGetPopularMovies mockGetPopularMovies;

  setUp(
    () {
      mockGetPopularMovies = MockGetPopularMovies();
      popularBlocMovie = PopularBlocMovie(mockGetPopularMovies);
    },
  );

  test(
    'initial state should be empty',
    () {
      expect(popularBlocMovie.state, PopularEmpty());
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

  blocTest<PopularBlocMovie, PopularStateMovie>(
    'Should emit [Loading, HasData] when data is gotten succesfully',
    build: () {
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return popularBlocMovie;
    },
    act: (bloc) => bloc.add(GetPopularMovie()),
    wait: const Duration(microseconds: 100),
    expect: () => [
      PopularLoading(),
      PopularHasData(tMovieList),
    ],
    verify: (bloc) {
      verify(mockGetPopularMovies.execute());
    },
  );

  blocTest<PopularBlocMovie, PopularStateMovie>(
    'Should emit [Loading, Error] when get Popular is unsuccessful',
    build: () {
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => left(ServerFailure('Server Failure.')));
      return popularBlocMovie;
    },
    act: (bloc) => bloc.add(GetPopularMovie()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      PopularLoading(),
      PopularError('Server Failure.'),
    ],
    verify: (bloc) {
      verify(mockGetPopularMovies.execute());
    },
  );
}
