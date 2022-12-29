import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/presentation/bloc/popular_bloc_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// import '../provider/tv_popular_notifier_test.mocks.dart';
import 'popular_bloc_tv_test.mocks.dart';

@GenerateMocks([GetPopularTvSeries])
void main() {
  late PopularBlocTv popularBlocTv;
  late MockGetPopularTvSeries mockGetPopularTvSeries;

  setUp(
    () {
      mockGetPopularTvSeries = MockGetPopularTvSeries();
      popularBlocTv = PopularBlocTv(mockGetPopularTvSeries);
    },
  );

  test(
    'initial state should be empty',
    () {
      expect(popularBlocTv.state, PopularEmpty());
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

  blocTest<PopularBlocTv, PopularStateTv>(
    'Should emit [Loading, HasData] when data is gotten succesfully',
    build: () {
      when(mockGetPopularTvSeries.execute())
          .thenAnswer((_) async => Right(tTvList));
      return popularBlocTv;
    },
    act: (bloc) => bloc.add(GetPopularTv()),
    wait: const Duration(microseconds: 100),
    expect: () => [
      PopularLoading(),
      PopularHasData(tTvList),
    ],
    verify: (bloc) {
      verify(mockGetPopularTvSeries.execute());
    },
  );

  blocTest<PopularBlocTv, PopularStateTv>(
    'Should emit [Loading, Error] when get Popular is unsuccessful',
    build: () {
      when(mockGetPopularTvSeries.execute())
          .thenAnswer((_) async => left(ServerFailure('Server Failure.')));
      return popularBlocTv;
    },
    act: (bloc) => bloc.add(GetPopularTv()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      PopularLoading(),
      PopularError('Server Failure.'),
    ],
    verify: (bloc) {
      verify(mockGetPopularTvSeries.execute());
    },
  );
}
