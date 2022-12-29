import 'package:ditonton/presentation/bloc/top_rated_bloc_tv.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockTopRatedBlocTv extends Mock implements TopRatedBlocTv {}

class TopRatedEventTvFake extends Fake implements TopRatedEventTv {}

class TopRatedStateTvFake extends Fake implements TopRatedStateTv {}

void main() {
  late TopRatedBlocTv topRatedBlocTv;

  setUpAll(() {
    registerFallbackValue(TopRatedEventTvFake());
    registerFallbackValue(TopRatedStateTvFake());
  });

  setUp(() {
    topRatedBlocTv = MockTopRatedBlocTv();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedBlocTv>.value(
      value: topRatedBlocTv,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => topRatedBlocTv.stream)
        .thenAnswer((_) => Stream.value(TopRatedLoading()));
    when(() => topRatedBlocTv.state).thenReturn(TopRatedLoading());

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(TopRatedTvSeriesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => topRatedBlocTv.stream)
        .thenAnswer((_) => Stream.value(TopRatedHasData(testTvList)));
    when(() => topRatedBlocTv.state).thenReturn(TopRatedHasData(testTvList));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(TopRatedTvSeriesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => topRatedBlocTv.stream)
        .thenAnswer((_) => Stream.value(TopRatedError('Error message')));
    when(() => topRatedBlocTv.state).thenReturn(TopRatedError('Error message'));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(TopRatedTvSeriesPage()));

    expect(textFinder, findsOneWidget);
  });
}
