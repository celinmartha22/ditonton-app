import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/presentation/bloc/watchlist_bloc_movie.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_bloc_movie_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies])
void main() {
  late WatchlistBlocMovie watchlistBlocMovie;
  late MockGetWatchlistMovies mockGetWatchlistMovies;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    watchlistBlocMovie = WatchlistBlocMovie(mockGetWatchlistMovies);
  });

  blocTest<WatchlistBlocMovie, WatchlistStateMovie>(
    'should change movies data when data is gotten successfully',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Right([testWatchlistMovie]));
      return watchlistBlocMovie;
    },
    act: (bloc) => bloc.add(GetWatchlistMovie()),
    expect: () => [
      WatchlistLoading(),
      WatchlistHasData([testWatchlistMovie]),
    ],
  );

  blocTest<WatchlistBlocMovie, WatchlistStateMovie>(
    'should return error when data is unsuccessful',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Left(DatabaseFailure("Can't get data")));
      return watchlistBlocMovie;
    },
    act: (bloc) => bloc.add(GetWatchlistMovie()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      WatchlistLoading(),
      WatchlistError("Can't get data"),
    ],
  );
}
