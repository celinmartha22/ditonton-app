import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_tv.dart';
import 'package:ditonton/domain/usecases/remove_tv_watchlist.dart';
import 'package:ditonton/domain/usecases/save_tv_watchlist.dart';
import 'package:ditonton/presentation/bloc/detail_bloc_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'detail_bloc_tv_test.mocks.dart';

@GenerateMocks([
  GetTvDetail,
  GetTvRecommendations,
  GetWatchListStatusTv,
  SaveTvWatchlist,
  RemoveTvWatchlist,
])
void main() {
  late DetailBlocTv detailBlocTv;
  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvRecommendations mockGetTvRecommendations;
  late MockGetWatchListStatusTv mockGetWatchlistStatusTv;
  late MockSaveTvWatchlist mockSaveTvWatchlist;
  late MockRemoveTvWatchlist mockRemoveTvWatchlist;

  setUp(
    () {
      mockGetTvDetail = MockGetTvDetail();
      mockGetTvRecommendations = MockGetTvRecommendations();
      mockGetWatchlistStatusTv = MockGetWatchListStatusTv();
      mockSaveTvWatchlist = MockSaveTvWatchlist();
      mockRemoveTvWatchlist = MockRemoveTvWatchlist();
      detailBlocTv = DetailBlocTv(mockGetTvDetail, mockGetTvRecommendations,
          mockGetWatchlistStatusTv, mockSaveTvWatchlist, mockRemoveTvWatchlist);
    },
  );

  test(
    'initial state should be empty',
    () {
      expect(detailBlocTv.state, DetailEmpty());
    },
  );

  final tId = 1;
  final tWatchlistStatus = true;
  final tTv = Tv(
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    firstAirDate: 'firstAirDate',
    genreIds: [14, 28],
    id: 557,
    name: 'Spiderman',
    originCountry: ['US'],
    originalLanguage: 'originalLanguage',
    originalName: 'originalName',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    voteAverage: 7.2,
    voteCount: 13507,
  );
  final tTvSeries = <Tv>[tTv];

  arrangeUsecase() {
    when(mockGetTvDetail.execute(tId))
        .thenAnswer((_) async => Right(testTvDetail));
    when(mockGetTvRecommendations.execute(tId))
        .thenAnswer((_) async => Right(tTvSeries));
    when(mockGetWatchlistStatusTv.execute(tId)).thenAnswer((_) async => true);
    when(mockSaveTvWatchlist.execute(testTvDetail))
        .thenAnswer((_) async => Right('Success'));
    when(mockRemoveTvWatchlist.execute(testTvDetail))
        .thenAnswer((_) async => Right('Success'));
    return detailBlocTv;
  }

  group('Get Tv Detail', () {
    blocTest<DetailBlocTv, DetailStateTv>(
      'should get data from the usecase',
      build: () {
        return arrangeUsecase();
      },
      act: (bloc) => bloc.add(GetDetailTv(tId)),
      wait: const Duration(milliseconds: 1000),
      verify: (bloc) {
        verify(mockGetTvDetail.execute(tId));
        verify(mockGetTvRecommendations.execute(tId));
      },
    );

    blocTest<DetailBlocTv, DetailStateTv>(
      'should change state to Loading when usecase is called',
      build: () {
        return arrangeUsecase();
      },
      act: (bloc) => bloc.add(GetDetailTv(tId)),
      wait: const Duration(milliseconds: 1000),
      expect: () => [
        DetailLoading(),
        RecommendationLoading(),
        RecommendationHasData(tTvSeries),
        DetailHasData(testTvDetail, tTvSeries, tWatchlistStatus),
      ],
    );

    blocTest<DetailBlocTv, DetailStateTv>(
      'should change Tv when data is gotten successfully',
      build: () {
        return arrangeUsecase();
      },
      act: (bloc) => bloc.add(GetDetailTv(tId)),
      wait: const Duration(milliseconds: 1000),
      expect: () => [
        DetailLoading(),
        RecommendationLoading(),
        RecommendationHasData(tTvSeries),
        DetailHasData(testTvDetail, tTvSeries, tWatchlistStatus),
      ],
    );

    blocTest<DetailBlocTv, DetailStateTv>(
      'should change recommendation Tvs when data is gotten successfull',
      build: () {
        return arrangeUsecase();
      },
      act: (bloc) => bloc.add(GetDetailTv(tId)),
      wait: const Duration(milliseconds: 1000),
      expect: () => [
        DetailLoading(),
        RecommendationLoading(),
        RecommendationHasData(tTvSeries),
        DetailHasData(testTvDetail, tTvSeries, tWatchlistStatus),
      ],
    );
  });

  group('Get Tv Recommendations', () {
    blocTest<DetailBlocTv, DetailStateTv>(
      'should get data from the usecase',
      build: () {
        return arrangeUsecase();
      },
      act: (bloc) => bloc.add(GetDetailTv(tId)),
      wait: const Duration(milliseconds: 1000),
      verify: (bloc) => verify(mockGetTvRecommendations.execute(tId)),
      expect: () => [
        DetailLoading(),
        RecommendationLoading(),
        RecommendationHasData(tTvSeries),
        DetailHasData(testTvDetail, tTvSeries, tWatchlistStatus),
      ],
    );

    blocTest<DetailBlocTv, DetailStateTv>(
      'should update recommendation state when data is gotten successfully',
      build: () {
        return arrangeUsecase();
      },
      act: (bloc) => bloc.add(GetDetailTv(tId)),
      wait: const Duration(milliseconds: 1000),
      expect: () => [
        DetailLoading(),
        RecommendationLoading(),
        RecommendationHasData(tTvSeries),
        DetailHasData(testTvDetail, tTvSeries, tWatchlistStatus),
      ],
    );

    blocTest<DetailBlocTv, DetailStateTv>(
      'should update error message when request in successful',
      build: () {
        when(mockGetTvDetail.execute(tId))
            .thenAnswer((_) async => Right(testTvDetail));
        when(mockGetTvRecommendations.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(mockGetWatchlistStatusTv.execute(tId))
            .thenAnswer((_) async => false);
        when(mockSaveTvWatchlist.execute(testTvDetail))
            .thenAnswer((_) async => Right('Failed'));
        when(mockRemoveTvWatchlist.execute(testTvDetail))
            .thenAnswer((_) async => Right('Failed'));
        return detailBlocTv;
      },
      act: (bloc) => bloc.add(GetDetailTv(tId)),
      wait: const Duration(milliseconds: 1000),
      expect: () => [
        DetailLoading(),
        RecommendationLoading(),
        RecommendationError('Server Failure'),
        DetailHasData(testTvDetail, <Tv>[], false),
      ],
    );
  });

  group('Watchlist', () {
    blocTest<DetailBlocTv, DetailStateTv>(
      'should get the watchlist status',
      build: () {
        when(mockGetWatchlistStatusTv.execute(tId))
            .thenAnswer((_) async => true);
        return detailBlocTv;
      },
      act: (bloc) => bloc.add(LoadWatchlistStatus(tId)),
      wait: const Duration(milliseconds: 1000),
      expect: () => [
        DetailLoading(),
        DetailHasStatus(true),
      ],
    );

    blocTest<DetailBlocTv, DetailStateTv>(
      'should execute save watchlist when function called',
      build: () {
        when(mockSaveTvWatchlist.execute(testTvDetail))
            .thenAnswer((_) async => Right('Success'));
        when(mockGetWatchlistStatusTv.execute(testTvDetail.id))
            .thenAnswer((_) async => true);
        return detailBlocTv;
      },
      act: (bloc) => bloc.add(AddWatchlist(testTvDetail)),
      wait: const Duration(milliseconds: 1000),
      verify: (bloc) => verify(mockSaveTvWatchlist.execute(testTvDetail)),
    );

    blocTest<DetailBlocTv, DetailStateTv>(
      'should execute remove watchlist when function called',
      build: () {
        when(mockRemoveTvWatchlist.execute(testTvDetail))
            .thenAnswer((_) async => Right('Removed'));
        when(mockGetWatchlistStatusTv.execute(testTvDetail.id))
            .thenAnswer((_) async => false);
        return detailBlocTv;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlist(testTvDetail)),
      wait: const Duration(milliseconds: 1000),
      verify: (bloc) => verify(mockRemoveTvWatchlist.execute(testTvDetail)),
    );

    blocTest<DetailBlocTv, DetailStateTv>(
      'should update watchlist status when add watchlist success',
      build: () {
        when(mockSaveTvWatchlist.execute(testTvDetail))
            .thenAnswer((_) async => Right('Added to Watchlist'));
        when(mockGetWatchlistStatusTv.execute(testTvDetail.id))
            .thenAnswer((_) async => true);
        return detailBlocTv;
      },
      act: (bloc) => bloc.add(AddWatchlist(testTvDetail)),
      wait: const Duration(milliseconds: 1000),
      verify: (bloc) =>
          verify(mockGetWatchlistStatusTv.execute(testTvDetail.id)),
      expect: () => [
        DetailLoading(),
        DetailHasMessage('Added to Watchlist'),
        DetailLoading(),
        DetailHasStatus(true),
      ],
    );

    blocTest<DetailBlocTv, DetailStateTv>(
      'should update watchlist status when add watchlist failed',
      build: () {
        when(mockSaveTvWatchlist.execute(testTvDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(mockGetWatchlistStatusTv.execute(testTvDetail.id))
            .thenAnswer((_) async => false);
        return detailBlocTv;
      },
      act: (bloc) => bloc.add(AddWatchlist(testTvDetail)),
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
    blocTest<DetailBlocTv, DetailStateTv>(
      'should return error when data is unsuccessful',
      build: () {
        when(mockGetTvDetail.execute(tId))
            .thenAnswer((_) async => left(ServerFailure('Server Failure')));
        when(mockGetTvRecommendations.execute(tId))
            .thenAnswer((_) async => left(ServerFailure('Server Failure')));
        when(mockGetWatchlistStatusTv.execute(tId))
            .thenAnswer((_) async => false);
        when(mockSaveTvWatchlist.execute(testTvDetail))
            .thenAnswer((_) async => Right('Failed'));
        when(mockRemoveTvWatchlist.execute(testTvDetail))
            .thenAnswer((_) async => Right('Failed'));
        return detailBlocTv;
      },
      act: (bloc) => bloc.add(GetDetailTv(tId)),
      wait: const Duration(milliseconds: 1000),
      expect: () => [DetailLoading(), DetailError('Server Failure')],
    );
  });

  blocTest<DetailBlocTv, DetailStateTv>(
    'Should emit [Loading, HasData] when data is gotten succesfully',
    build: () {
      return arrangeUsecase();
    },
    act: (bloc) => bloc.add(GetDetailTv(tId)),
    wait: const Duration(milliseconds: 1000),
    expect: () => [
      DetailLoading(),
      RecommendationLoading(),
      RecommendationHasData(tTvSeries),
      DetailHasData(testTvDetail, tTvSeries, tWatchlistStatus),
    ],
    verify: (bloc) {
      verify(mockGetTvDetail.execute(tId));
    },
  );

  blocTest<DetailBlocTv, DetailStateTv>(
    'Should emit [Loading, Error] when get Detail is unsuccessful',
    build: () {
      when(mockGetTvDetail.execute(tId))
          .thenAnswer((_) async => left(ServerFailure('Server Failure')));
      when(mockGetTvRecommendations.execute(tId))
          .thenAnswer((_) async => left(ServerFailure('Server Failure')));
      when(mockGetWatchlistStatusTv.execute(tId))
          .thenAnswer((_) async => false);
      when(mockSaveTvWatchlist.execute(testTvDetail))
          .thenAnswer((_) async => Right('Failed'));
      when(mockRemoveTvWatchlist.execute(testTvDetail))
          .thenAnswer((_) async => Right('Failed'));
      return detailBlocTv;
    },
    act: (bloc) => bloc.add(GetDetailTv(tId)),
    wait: const Duration(milliseconds: 1000),
    expect: () => [
      DetailLoading(),
      DetailError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetTvDetail.execute(tId));
    },
  );
}
