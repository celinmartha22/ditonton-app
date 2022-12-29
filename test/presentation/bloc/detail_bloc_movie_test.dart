import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/detail_bloc_movie.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'detail_bloc_movie_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late DetailBlocMovie detailBlocMovie;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatus mockGetWatchlistStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(
    () {
      mockGetMovieDetail = MockGetMovieDetail();
      mockGetMovieRecommendations = MockGetMovieRecommendations();
      mockGetWatchlistStatus = MockGetWatchListStatus();
      mockSaveWatchlist = MockSaveWatchlist();
      mockRemoveWatchlist = MockRemoveWatchlist();
      detailBlocMovie = DetailBlocMovie(
          mockGetMovieDetail,
          mockGetMovieRecommendations,
          mockGetWatchlistStatus,
          mockSaveWatchlist,
          mockRemoveWatchlist);
    },
  );

  test(
    'initial state should be empty',
    () {
      expect(detailBlocMovie.state, DetailEmpty());
    },
  );

  final tId = 1;
  final tWatchlistStatus = true;
  final tTv = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );
  final tMovies = <Movie>[tTv];

  arrangeUsecase() {
    when(mockGetMovieDetail.execute(tId))
        .thenAnswer((_) async => Right(testMovieDetail));
    when(mockGetMovieRecommendations.execute(tId))
        .thenAnswer((_) async => Right(tMovies));
    when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => true);
    when(mockSaveWatchlist.execute(testMovieDetail))
        .thenAnswer((_) async => Right('Success'));
    when(mockRemoveWatchlist.execute(testMovieDetail))
        .thenAnswer((_) async => Right('Success'));
    return detailBlocMovie;
  }

  group('Get Tv Detail', () {
    blocTest<DetailBlocMovie, DetailStateMovie>(
      'should get data from the usecase',
      build: () {
        return arrangeUsecase();
      },
      act: (bloc) => bloc.add(GetDetailMovie(tId)),
      wait: const Duration(milliseconds: 1000),
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
      },
    );

    blocTest<DetailBlocMovie, DetailStateMovie>(
      'should change state to Loading when usecase is called',
      build: () {
        return arrangeUsecase();
      },
      act: (bloc) => bloc.add(GetDetailMovie(tId)),
      wait: const Duration(milliseconds: 1000),
      expect: () => [
        DetailLoading(),
        RecommendationLoading(),
        RecommendationHasData(tMovies),
        DetailHasData(testMovieDetail, tMovies, tWatchlistStatus),
      ],
    );

    blocTest<DetailBlocMovie, DetailStateMovie>(
      'should change Tv when data is gotten successfully',
      build: () {
        return arrangeUsecase();
      },
      act: (bloc) => bloc.add(GetDetailMovie(tId)),
      wait: const Duration(milliseconds: 1000),
      expect: () => [
        DetailLoading(),
        RecommendationLoading(),
        RecommendationHasData(tMovies),
        DetailHasData(testMovieDetail, tMovies, tWatchlistStatus),
      ],
    );

    blocTest<DetailBlocMovie, DetailStateMovie>(
      'should change recommendation Tvs when data is gotten successfull',
      build: () {
        return arrangeUsecase();
      },
      act: (bloc) => bloc.add(GetDetailMovie(tId)),
      wait: const Duration(milliseconds: 1000),
      expect: () => [
        DetailLoading(),
        RecommendationLoading(),
        RecommendationHasData(tMovies),
        DetailHasData(testMovieDetail, tMovies, tWatchlistStatus),
      ],
    );
  });

  group('Get Tv Recommendations', () {
    blocTest<DetailBlocMovie, DetailStateMovie>(
      'should get data from the usecase',
      build: () {
        return arrangeUsecase();
      },
      act: (bloc) => bloc.add(GetDetailMovie(tId)),
      wait: const Duration(milliseconds: 1000),
      verify: (bloc) => verify(mockGetMovieRecommendations.execute(tId)),
      expect: () => [
        DetailLoading(),
        RecommendationLoading(),
        RecommendationHasData(tMovies),
        DetailHasData(testMovieDetail, tMovies, tWatchlistStatus),
      ],
    );

    blocTest<DetailBlocMovie, DetailStateMovie>(
      'should update recommendation state when data is gotten successfully',
      build: () {
        return arrangeUsecase();
      },
      act: (bloc) => bloc.add(GetDetailMovie(tId)),
      wait: const Duration(milliseconds: 1000),
      expect: () => [
        DetailLoading(),
        RecommendationLoading(),
        RecommendationHasData(tMovies),
        DetailHasData(testMovieDetail, tMovies, tWatchlistStatus),
      ],
    );

    blocTest<DetailBlocMovie, DetailStateMovie>(
      'should update error message when request in successful',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Right(testMovieDetail));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(mockGetWatchlistStatus.execute(tId))
            .thenAnswer((_) async => false);
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Right('Failed'));
        when(mockRemoveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Right('Failed'));
        return detailBlocMovie;
      },
      act: (bloc) => bloc.add(GetDetailMovie(tId)),
      wait: const Duration(milliseconds: 1000),
      expect: () => [
        DetailLoading(),
        RecommendationLoading(),
        RecommendationError('Server Failure'),
        DetailHasData(testMovieDetail, <Movie>[], false),
      ],
    );
  });

  group('Watchlist', () {
    blocTest<DetailBlocMovie, DetailStateMovie>(
      'should get the watchlist status',
      build: () {
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => true);
        return detailBlocMovie;
      },
      act: (bloc) => bloc.add(LoadWatchlistStatus(tId)),
      wait: const Duration(milliseconds: 1000),
      expect: () => [
        DetailLoading(),
        DetailHasStatus(true),
      ],
    );

    blocTest<DetailBlocMovie, DetailStateMovie>(
      'should execute save watchlist when function called',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Right('Success'));
        when(mockGetWatchlistStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => true);
        return detailBlocMovie;
      },
      act: (bloc) => bloc.add(AddWatchlist(testMovieDetail)),
      wait: const Duration(milliseconds: 1000),
      verify: (bloc) => verify(mockSaveWatchlist.execute(testMovieDetail)),
    );

    blocTest<DetailBlocMovie, DetailStateMovie>(
      'should execute remove watchlist when function called',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Right('Removed'));
        when(mockGetWatchlistStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);
        return detailBlocMovie;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlist(testMovieDetail)),
      wait: const Duration(milliseconds: 1000),
      verify: (bloc) => verify(mockRemoveWatchlist.execute(testMovieDetail)),
    );

    blocTest<DetailBlocMovie, DetailStateMovie>(
      'should update watchlist status when add watchlist success',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Right('Added to Watchlist'));
        when(mockGetWatchlistStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => true);
        return detailBlocMovie;
      },
      act: (bloc) => bloc.add(AddWatchlist(testMovieDetail)),
      wait: const Duration(milliseconds: 1000),
      verify: (bloc) =>
          verify(mockGetWatchlistStatus.execute(testMovieDetail.id)),
      expect: () => [
        DetailLoading(),
        DetailHasMessage('Added to Watchlist'),
        DetailLoading(),
        DetailHasStatus(true),
      ],
    );

    blocTest<DetailBlocMovie, DetailStateMovie>(
      'should update watchlist status when add watchlist failed',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(mockGetWatchlistStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);
        return detailBlocMovie;
      },
      act: (bloc) => bloc.add(AddWatchlist(testMovieDetail)),
      wait: const Duration(milliseconds: 1000),
      expect: () => [
        DetailLoading(),
        DetailError('Failed'),
        DetailLoading(),
        DetailHasStatus(false),
      ],
    );
  });

  group('on Error', () {
    blocTest<DetailBlocMovie, DetailStateMovie>(
      'should return error when data is unsuccessful',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => left(ServerFailure('Server Failure')));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => left(ServerFailure('Server Failure')));
        when(mockGetWatchlistStatus.execute(tId))
            .thenAnswer((_) async => false);
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Right('Failed'));
        when(mockRemoveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Right('Failed'));
        return detailBlocMovie;
      },
      act: (bloc) => bloc.add(GetDetailMovie(tId)),
      wait: const Duration(milliseconds: 1000),
      expect: () => [DetailLoading(), DetailError('Server Failure')],
    );
  });

  blocTest<DetailBlocMovie, DetailStateMovie>(
    'Should emit [Loading, HasData] when data is gotten succesfully',
    build: () {
      return arrangeUsecase();
    },
    act: (bloc) => bloc.add(GetDetailMovie(tId)),
    wait: const Duration(milliseconds: 1000),
    expect: () => [
      DetailLoading(),
      RecommendationLoading(),
      RecommendationHasData(tMovies),
      DetailHasData(testMovieDetail, tMovies, tWatchlistStatus),
    ],
    verify: (bloc) {
      verify(mockGetMovieDetail.execute(tId));
    },
  );

  blocTest<DetailBlocMovie, DetailStateMovie>(
    'Should emit [Loading, Error] when get Detail is unsuccessful',
    build: () {
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => left(ServerFailure('Server Failure')));
      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => left(ServerFailure('Server Failure')));
      when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => false);
      when(mockSaveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => Right('Failed'));
      when(mockRemoveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => Right('Failed'));
      return detailBlocMovie;
    },
    act: (bloc) => bloc.add(GetDetailMovie(tId)),
    wait: const Duration(milliseconds: 1000),
    expect: () => [
      DetailLoading(),
      DetailError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetMovieDetail.execute(tId));
    },
  );
}
