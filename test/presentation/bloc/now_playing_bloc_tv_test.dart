import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv_series.dart';
import 'package:ditonton/presentation/bloc/now_playing_bloc_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// import '../provider/tv_now_playing_notifier_test.mocks.dart';
import 'now_playing_bloc_tv_test.mocks.dart';

@GenerateMocks([GetNowPlayingTvSeries])
void main() {
  late NowPlayingBlocTv nowPlayingBlocTv;
  late MockGetNowPlayingTvSeries mockGetNowPlayingTvSeries;

  setUp(
    () {
      mockGetNowPlayingTvSeries = MockGetNowPlayingTvSeries();
      nowPlayingBlocTv = NowPlayingBlocTv(mockGetNowPlayingTvSeries);
    },
  );

  test(
    'initial state should be empty',
    () {
      expect(nowPlayingBlocTv.state, NowPlayingEmpty());
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

  blocTest<NowPlayingBlocTv, NowPlayingStateTv>(
    'Should emit [Loading, HasData] when data is gotten succesfully',
    build: () {
      when(mockGetNowPlayingTvSeries.execute())
          .thenAnswer((_) async => Right(tTvList));
      return nowPlayingBlocTv;
    },
    act: (bloc) => bloc.add(GetNowPlayingTv()),
    wait: const Duration(microseconds: 100),
    expect: () => [
      NowPlayingLoading(),
      NowPlayingHasData(tTvList),
    ],
    verify: (bloc) {
      verify(mockGetNowPlayingTvSeries.execute());
    },
  );

  blocTest<NowPlayingBlocTv, NowPlayingStateTv>(
    'Should emit [Loading, Error] when get NowPlaying is unsuccessful',
    build: () {
      when(mockGetNowPlayingTvSeries.execute())
          .thenAnswer((_) async => left(ServerFailure('Server Failure.')));
      return nowPlayingBlocTv;
    },
    act: (bloc) => bloc.add(GetNowPlayingTv()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      NowPlayingLoading(),
      NowPlayingError('Server Failure.'),
    ],
    verify: (bloc) {
      verify(mockGetNowPlayingTvSeries.execute());
    },
  );
}
