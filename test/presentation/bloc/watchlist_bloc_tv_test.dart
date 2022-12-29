import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_series.dart';
import 'package:ditonton/presentation/bloc/watchlist_bloc_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_bloc_tv_test.mocks.dart';

@GenerateMocks([GetWatchlistTvSeries])
void main() {
  late WatchlistBlocTv watchlistBlocTv;
  late MockGetWatchlistTvSeries mockGetWatchlistTvSeries;

  setUp(() {
    mockGetWatchlistTvSeries = MockGetWatchlistTvSeries();
    watchlistBlocTv = WatchlistBlocTv(mockGetWatchlistTvSeries);
  });

  blocTest<WatchlistBlocTv, WatchlistStateTv>(
    'should change movies data when data is gotten successfully',
    build: () {
      when(mockGetWatchlistTvSeries.execute())
          .thenAnswer((_) async => Right([testWatchlistTv]));
      return watchlistBlocTv;
    },
    act: (bloc) => bloc.add(GetWatchlistTv()),
    expect: () => [
      WatchlistLoading(),
      WatchlistHasData([testWatchlistTv]),
    ],
  );

  blocTest<WatchlistBlocTv, WatchlistStateTv>(
    'should return error when data is unsuccessful',
    build: () {
      when(mockGetWatchlistTvSeries.execute())
          .thenAnswer((_) async => Left(DatabaseFailure("Can't get data")));
      return watchlistBlocTv;
    },
    act: (bloc) => bloc.add(GetWatchlistTv()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      WatchlistLoading(),
      WatchlistError("Can't get data"),
    ],
  );
}
