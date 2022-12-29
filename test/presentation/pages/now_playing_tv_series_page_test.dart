import 'package:ditonton/presentation/bloc/now_playing_bloc_tv.dart';
import 'package:ditonton/presentation/pages/now_playing_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockNowPlayingBlocTv extends Mock implements NowPlayingBlocTv {}

class NowPlayingEventTvFake extends Fake implements NowPlayingEventTv {}

class NowPlayingStateTvFake extends Fake implements NowPlayingStateTv {}

void main() {
  late NowPlayingBlocTv nowPlayingBlocTv;

  setUpAll(() {
    registerFallbackValue(NowPlayingEventTvFake());
    registerFallbackValue(NowPlayingStateTvFake());
  });

  setUp(() {
    nowPlayingBlocTv = MockNowPlayingBlocTv();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<NowPlayingBlocTv>.value(
      value: nowPlayingBlocTv,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => nowPlayingBlocTv.stream)
        .thenAnswer((_) => Stream.value(NowPlayingLoading()));
    when(() => nowPlayingBlocTv.state).thenReturn(NowPlayingLoading());

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(NowPlayingTvSeriesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => nowPlayingBlocTv.stream)
        .thenAnswer((_) => Stream.value(NowPlayingHasData(testTvList)));
    when(() => nowPlayingBlocTv.state)
        .thenReturn(NowPlayingHasData(testTvList));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(NowPlayingTvSeriesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => nowPlayingBlocTv.stream)
        .thenAnswer((_) => Stream.value(NowPlayingError('Error message')));
    when(() => nowPlayingBlocTv.state)
        .thenReturn(NowPlayingError('Error message'));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(NowPlayingTvSeriesPage()));

    expect(textFinder, findsOneWidget);
  });
}
