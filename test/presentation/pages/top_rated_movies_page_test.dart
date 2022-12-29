import 'package:ditonton/presentation/bloc/top_rated_bloc_movie.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockTopRatedBlocMovie extends Mock implements TopRatedBlocMovie {}

class TopRatedEventMovieFake extends Fake implements TopRatedEventMovie {}

class TopRatedStateMovieFake extends Fake implements TopRatedStateMovie {}

void main() {
  late TopRatedBlocMovie topRatedBlocMovie;

  setUpAll(() {
    registerFallbackValue(TopRatedEventMovieFake());
    registerFallbackValue(TopRatedStateMovieFake());
  });

  setUp(() {
    topRatedBlocMovie = MockTopRatedBlocMovie();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedBlocMovie>.value(
      value: topRatedBlocMovie,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => topRatedBlocMovie.stream)
        .thenAnswer((_) => Stream.value(TopRatedLoading()));
    when(() => topRatedBlocMovie.state).thenReturn(TopRatedLoading());

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => topRatedBlocMovie.stream)
        .thenAnswer((_) => Stream.value(TopRatedHasData(testMovieList)));
    when(() => topRatedBlocMovie.state)
        .thenReturn(TopRatedHasData(testMovieList));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => topRatedBlocMovie.stream)
        .thenAnswer((_) => Stream.value(TopRatedError('Error message')));
    when(() => topRatedBlocMovie.state)
        .thenReturn(TopRatedError('Error message'));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(textFinder, findsOneWidget);
  });
}
