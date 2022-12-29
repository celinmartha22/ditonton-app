import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/presentation/bloc/now_playing_bloc_movie.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// import '../provider/movie_now_playing_notifier_test.mocks.dart';
import 'now_playing_bloc_movie_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies])
void main() {
  late NowPlayingBlocMovie nowPlayingBlocMovie;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;

  setUp(
    () {
      mockGetNowPlayingMovies = MockGetNowPlayingMovies();
      nowPlayingBlocMovie = NowPlayingBlocMovie(mockGetNowPlayingMovies);
    },
  );

  test(
    'initial state should be empty',
    () {
      expect(nowPlayingBlocMovie.state, NowPlayingEmpty());
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

  blocTest<NowPlayingBlocMovie, NowPlayingStateMovie>(
    'Should emit [Loading, HasData] when data is gotten succesfully',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return nowPlayingBlocMovie;
    },
    act: (bloc) => bloc.add(GetNowPlayingMovie()),
    wait: const Duration(microseconds: 100),
    expect: () => [
      NowPlayingLoading(),
      NowPlayingHasData(tMovieList),
    ],
    verify: (bloc) {
      verify(mockGetNowPlayingMovies.execute());
    },
  );

  blocTest<NowPlayingBlocMovie, NowPlayingStateMovie>(
    'Should emit [Loading, Error] when get NowPlaying is unsuccessful',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => left(ServerFailure('Server Failure.')));
      return nowPlayingBlocMovie;
    },
    act: (bloc) => bloc.add(GetNowPlayingMovie()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      NowPlayingLoading(),
      NowPlayingError('Server Failure.'),
    ],
    verify: (bloc) {
      verify(mockGetNowPlayingMovies.execute());
    },
  );
}
