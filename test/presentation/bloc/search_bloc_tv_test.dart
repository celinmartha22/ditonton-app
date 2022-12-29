import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:ditonton/presentation/bloc/search_bloc_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// import '../provider/tv_search_notifier_test.mocks.dart';
import 'search_bloc_tv_test.mocks.dart';

@GenerateMocks([SearchTvSeries])
void main() {
  late SearchBlocTv searchBlocTv;
  late MockSearchTvSeries mockSearchTvSeries;

  setUp(
    () {
      mockSearchTvSeries = MockSearchTvSeries();
      searchBlocTv = SearchBlocTv(mockSearchTvSeries);
    },
  );

  test(
    'initial state should be empty',
    () {
      expect(searchBlocTv.state, SearchEmpty());
    },
  );

  final tTvModel = Tv(
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

  final tTvList = <Tv>[tTvModel];
  final tQuery = "spiderman";

  blocTest<SearchBlocTv, SearchStateTv>(
    'Should emit [Loading, HasData] when data is gotten succesfully',
    build: () {
      when(mockSearchTvSeries.execute(tQuery))
          .thenAnswer((_) async => Right(tTvList));
      return searchBlocTv;
    },
    act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchLoading(),
      SearchHasData(tTvList),
    ],
    verify: (bloc) {
      verify(mockSearchTvSeries.execute(tQuery));
    },
  );

  blocTest<SearchBlocTv, SearchStateTv>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockSearchTvSeries.execute(tQuery))
          .thenAnswer((_) async => left(ServerFailure('Server Failure.')));
      return searchBlocTv;
    },
    act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchLoading(),
      SearchError('Server Failure.'),
    ],
    verify: (bloc) {
      verify(mockSearchTvSeries.execute(tQuery));
    },
  );
}
