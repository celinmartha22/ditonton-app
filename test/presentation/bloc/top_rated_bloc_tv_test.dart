import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:ditonton/presentation/bloc/top_rated_bloc_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// import '../provider/tv_top_rated_notifier_test.mocks.dart';
import 'top_rated_bloc_tv_test.mocks.dart';

@GenerateMocks([GetTopRatedTvSeries])
void main() {
  late TopRatedBlocTv topRatedBlocTv;
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;

  setUp(
    () {
      mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();
      topRatedBlocTv = TopRatedBlocTv(mockGetTopRatedTvSeries);
    },
  );

  test(
    'initial state should be empty',
    () {
      expect(topRatedBlocTv.state, TopRatedEmpty());
    },
  );

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

  final tTvList = <Tv>[tTv];

  blocTest<TopRatedBlocTv, TopRatedStateTv>(
    'Should emit [Loading, HasData] when data is gotten succesfully',
    build: () {
      when(mockGetTopRatedTvSeries.execute())
          .thenAnswer((_) async => Right(tTvList));
      return topRatedBlocTv;
    },
    act: (bloc) => bloc.add(GetTopRatedTv()),
    wait: const Duration(microseconds: 100),
    expect: () => [
      TopRatedLoading(),
      TopRatedHasData(tTvList),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedTvSeries.execute());
    },
  );

  blocTest<TopRatedBlocTv, TopRatedStateTv>(
    'Should emit [Loading, Error] when get TopRated is unsuccessful',
    build: () {
      when(mockGetTopRatedTvSeries.execute())
          .thenAnswer((_) async => left(ServerFailure('Server Failure.')));
      return topRatedBlocTv;
    },
    act: (bloc) => bloc.add(GetTopRatedTv()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TopRatedLoading(),
      TopRatedError('Server Failure.'),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedTvSeries.execute());
    },
  );
}
