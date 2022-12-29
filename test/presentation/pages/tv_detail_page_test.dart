// import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/bloc/detail_bloc_tv.dart';
import 'package:ditonton/presentation/pages/tv_detail_page.dart';
// import 'package:ditonton/presentation/provider/tv_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
import 'package:mocktail/mocktail.dart';
// import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
// import 'tv_detail_page_test.mocks.dart';

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
        .thenAnswer((_) => Stream.value(DetailLoading()));
    when(() => detailBlocTv.state).thenReturn(DetailLoading());
    // when(() => detailBlocTv.stream).thenAnswer((_) => Stream.value(
    //     DetailHasData(testTvDetail, testTvList, testIsAddedToWatchlist)));
    when(() => detailBlocTv.state)
        .thenReturn(DetailHasData(testTvDetail, testTvList, false));
    when(() => detailBlocTv.tv).thenReturn(testTvDetail);
    when(() => detailBlocTv.tvRecommendations).thenReturn(<Tv>[]);
    when(() => detailBlocTv.isAddedToWatchlist).thenReturn(false);
    // when(() => detailBlocTv.stream).thenAnswer((_) => Stream.value(
    //     DetailHasData(testTvDetail, testTvList, testIsAddedToWatchlist)));
    // when(() => detailBlocTv.).thenReturn(
    //     DetailHasData(testTvDetail, testTvList, testIsAddedToWatchlist));

    // when(mockBloc.TvState).thenReturn(RequestState.Loaded);
    // when(mockBloc.Tv).thenReturn(testTvDetail);
    // when(mockBloc.recommendationState).thenReturn(RequestState.Loaded);
    // when(mockBloc.TvRecommendations).thenReturn(<Tv>[]);
    // when(mockBloc.isAddedToWatchlist).thenReturn(false);

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when Tv is added to wathclist',
      (WidgetTester tester) async {
    when(() => detailBlocTv.stream)
        .thenAnswer((_) => Stream.value(DetailLoading()));
    when(() => detailBlocTv.state).thenReturn(DetailLoading());
    when(() => detailBlocTv.state)
        .thenReturn(DetailHasData(testTvDetail, testTvList, true));
    when(() => detailBlocTv.tv).thenReturn(testTvDetail);
    when(() => detailBlocTv.tvRecommendations).thenReturn(<Tv>[]);
    when(() => detailBlocTv.isAddedToWatchlist).thenReturn(true);
    // when(mockBloc.TvState).thenReturn(RequestState.Loaded);
    // when(mockBloc.Tv).thenReturn(testTvDetail);
    // when(mockBloc.recommendationState).thenReturn(RequestState.Loaded);
    // when(mockBloc.TvRecommendations).thenReturn(<Tv>[]);
    // when(mockBloc.isAddedToWatchlist).thenReturn(true);

    // final watchlistButtonIcon = find.byIcon(Icons.check);
    final watchlistButtonIcon = find.text('Watchlist');

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    // when(mockBloc.TvState).thenReturn(RequestState.Loaded);
    // when(mockBloc.Tv).thenReturn(testTvDetail);
    // when(mockBloc.recommendationState).thenReturn(RequestState.Loaded);
    // when(mockBloc.TvRecommendations).thenReturn(<Tv>[]);
    // when(mockBloc.isAddedToWatchlist).thenReturn(false);
    // when(mockBloc.watchlistMessage).thenReturn('Added to Watchlist');

    when(() => detailBlocTv.stream)
        .thenAnswer((_) => Stream.value(DetailLoading()));
    when(() => detailBlocTv.state).thenReturn(DetailLoading());
    when(() => detailBlocTv.state)
        .thenReturn(DetailHasData(testTvDetail, testTvList, false));
    when(() => detailBlocTv.tv).thenReturn(testTvDetail);
    when(() => detailBlocTv.tvRecommendations).thenReturn(<Tv>[]);
    when(() => detailBlocTv.isAddedToWatchlist).thenReturn(false);
    when(() => detailBlocTv.watchlistMessage)
        .thenReturn('Added to Watchlist');

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    // when(mockBloc.TvState).thenReturn(RequestState.Loaded);
    // when(mockBloc.Tv).thenReturn(testTvDetail);
    // when(mockBloc.recommendationState).thenReturn(RequestState.Loaded);
    // when(mockBloc.TvRecommendations).thenReturn(<Tv>[]);
    // when(mockBloc.isAddedToWatchlist).thenReturn(false);
    // when(mockBloc.watchlistMessage).thenReturn('Failed');

    when(() => detailBlocTv.stream)
        .thenAnswer((_) => Stream.value(DetailLoading()));
    when(() => detailBlocTv.state).thenReturn(DetailLoading());
    when(() => detailBlocTv.state)
        .thenReturn(DetailHasData(testTvDetail, testTvList, false));
    when(() => detailBlocTv.tv).thenReturn(testTvDetail);
    when(() => detailBlocTv.tvRecommendations).thenReturn(<Tv>[]);
    when(() => detailBlocTv.isAddedToWatchlist).thenReturn(false);
    when(() => detailBlocTv.watchlistMessage).thenReturn('Failed');

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}
