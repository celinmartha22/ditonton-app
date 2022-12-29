import 'package:ditonton/presentation/bloc/popular_bloc_tv.dart';
import 'package:ditonton/presentation/pages/popular_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../dummy_data/dummy_objects.dart';

class MockPopularBlocTv extends Mock implements PopularBlocTv {}

class PopularEventTvFake extends Fake implements PopularEventTv {}

class PopularStateTvFake extends Fake implements PopularStateTv {}

void main() {
  late PopularBlocTv popularBlocTv;

  setUpAll(() {
    registerFallbackValue(PopularEventTvFake());
    registerFallbackValue(PopularStateTvFake());
  });

  setUp(() {
    popularBlocTv = MockPopularBlocTv();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularBlocTv>.value(
      value: popularBlocTv,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => popularBlocTv.stream)
        .thenAnswer((_) => Stream.value(PopularLoading()));
    when(() => popularBlocTv.state).thenReturn(PopularLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(PopularTvSeriesPage()));
    
    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => popularBlocTv.stream)
        .thenAnswer((_) => Stream.value(PopularHasData(testTvList)));
    when(() => popularBlocTv.state)
        .thenReturn(PopularHasData(testTvList));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(PopularTvSeriesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => popularBlocTv.stream)
        .thenAnswer((_) => Stream.value(PopularError('Error message')));
    when(() => popularBlocTv.state)
        .thenReturn(PopularError('Error message'));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(PopularTvSeriesPage()));

    expect(textFinder, findsOneWidget);
  });
}
