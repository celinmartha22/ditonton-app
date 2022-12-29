import 'package:ditonton/presentation/bloc/popular_bloc_movie.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../dummy_data/dummy_objects.dart';

class MockPopularBlocMovie extends Mock implements PopularBlocMovie {}

class PopularEventMovieFake extends Fake implements PopularEventMovie {}

class PopularStateMovieFake extends Fake implements PopularStateMovie {}

void main() {
  late PopularBlocMovie popularBlocMovie;

  setUpAll(() {
    registerFallbackValue(PopularEventMovieFake());
    registerFallbackValue(PopularStateMovieFake());
  });

  setUp(() {
    popularBlocMovie = MockPopularBlocMovie();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularBlocMovie>.value(
      value: popularBlocMovie,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => popularBlocMovie.stream)
        .thenAnswer((_) => Stream.value(PopularLoading()));
    when(() => popularBlocMovie.state).thenReturn(PopularLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));
    
    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => popularBlocMovie.stream)
        .thenAnswer((_) => Stream.value(PopularHasData(testMovieList)));
    when(() => popularBlocMovie.state)
        .thenReturn(PopularHasData(testMovieList));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => popularBlocMovie.stream)
        .thenAnswer((_) => Stream.value(PopularError('Error message')));
    when(() => popularBlocMovie.state)
        .thenReturn(PopularError('Error message'));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    expect(textFinder, findsOneWidget);
  });
}
