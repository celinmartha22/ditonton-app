import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/detail_bloc_tv.dart';
import 'package:ditonton/presentation/pages/tv_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockDetailBlocTv extends Mock implements DetailBlocTv {}

class DetailEventTvFake extends Fake implements DetailEventTv {}

class DetailStateTvFake extends Fake implements DetailStateTv {}

void main() {
  late DetailBlocTv detailBlocTv;

  setUpAll(() {
    registerFallbackValue(DetailEventTvFake());
    registerFallbackValue(DetailStateTvFake());
  });

  setUp(() {
    detailBlocTv = MockDetailBlocTv();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<DetailBlocTv>.value(
      value: detailBlocTv,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when Tv not added to watchlist',
      (WidgetTester tester) async {
    when(() => detailBlocTv.stream)
        .thenAnswer((_) => Stream.value(DetailStateTv.initial().copyWith(
              tvDetail: testTvDetail,
              detailStateTv: RequestState.Loaded,
              tvRecommendationsState: RequestState.Loaded,
              isAddedToWatchlist: false,
            )));
    when(() => detailBlocTv.state).thenReturn(DetailStateTv.initial().copyWith(
      tvDetail: testTvDetail,
      detailStateTv: RequestState.Loaded,
      tvRecommendationsState: RequestState.Loaded,
      isAddedToWatchlist: false,
    ));

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when Tv is added to wathclist',
      (WidgetTester tester) async {
    when(() => detailBlocTv.stream)
        .thenAnswer((_) => Stream.value(DetailStateTv.initial().copyWith(
              tvDetail: testTvDetail,
              detailStateTv: RequestState.Loaded,
              tvRecommendationsState: RequestState.Loaded,
              isAddedToWatchlist: true,
            )));
    when(() => detailBlocTv.state).thenReturn(DetailStateTv.initial().copyWith(
      tvDetail: testTvDetail,
      detailStateTv: RequestState.Loaded,
      tvRecommendationsState: RequestState.Loaded,
      isAddedToWatchlist: true,
    ));

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    when(() => detailBlocTv.stream)
        .thenAnswer((_) => Stream.value(DetailStateTv.initial().copyWith(
              tvDetail: testTvDetail,
              detailStateTv: RequestState.Loaded,
              tvRecommendationsState: RequestState.Loaded,
              isAddedToWatchlist: false,
            )));
    when(() => detailBlocTv.state).thenReturn(DetailStateTv.initial().copyWith(
      tvDetail: testTvDetail,
      detailStateTv: RequestState.Loaded,
      tvRecommendationsState: RequestState.Loaded,
      isAddedToWatchlist: false,
    ));
    when(() => detailBlocTv.add(AddWatchlist(testTvDetail)))
        .thenAnswer((_) async => {});

    whenListen(
        detailBlocTv,
        Stream.fromIterable([
          detailBlocTv.state.copyWith(watchlistMessage: 'Added to Watchlist')
        ]));

    final watchlistButton = find.byType(ElevatedButton);
    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(watchlistButton, findsOneWidget);
    expect(watchlistButtonIcon, findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    when(() => detailBlocTv.stream)
        .thenAnswer((_) => Stream.value(DetailStateTv.initial().copyWith(
              tvDetail: testTvDetail,
              detailStateTv: RequestState.Loaded,
              tvRecommendationsState: RequestState.Loaded,
              isAddedToWatchlist: false,
            )));
    when(() => detailBlocTv.state).thenReturn(DetailStateTv.initial().copyWith(
      tvDetail: testTvDetail,
      detailStateTv: RequestState.Loaded,
      tvRecommendationsState: RequestState.Loaded,
      isAddedToWatchlist: false,
    ));

    when(() => detailBlocTv.add(AddWatchlist(testTvDetail)))
        .thenAnswer((_) async => {});

    whenListen(
        detailBlocTv,
        Stream.fromIterable(
            [detailBlocTv.state.copyWith(watchlistMessage: 'Failed')]));

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}
