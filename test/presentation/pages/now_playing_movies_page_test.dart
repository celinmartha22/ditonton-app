import 'package:ditonton/presentation/bloc/now_playing_bloc_movie.dart';
import 'package:ditonton/presentation/pages/now_playing_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockNowPlayingBlocMovie extends Mock implements NowPlayingBlocMovie {}

class NowPlayingEventMovieFake extends Fake implements NowPlayingEventMovie {}

class NowPlayingStateMovieFake extends Fake implements NowPlayingStateMovie {}

void main() {
  late NowPlayingBlocMovie nowPlayingBlocMovie;

  setUpAll(() {
    registerFallbackValue(NowPlayingEventMovieFake());
    registerFallbackValue(NowPlayingStateMovieFake());
  });

  setUp(() {
    nowPlayingBlocMovie = MockNowPlayingBlocMovie();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<NowPlayingBlocMovie>.value(
      value: nowPlayingBlocMovie,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => nowPlayingBlocMovie.stream)
        .thenAnswer((_) => Stream.value(NowPlayingLoading()));
    when(() => nowPlayingBlocMovie.state).thenReturn(NowPlayingLoading());

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(NowPlayingMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => nowPlayingBlocMovie.stream)
        .thenAnswer((_) => Stream.value(NowPlayingHasData(testMovieList)));
    when(() => nowPlayingBlocMovie.state)
        .thenReturn(NowPlayingHasData(testMovieList));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(NowPlayingMoviesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => nowPlayingBlocMovie.stream)
        .thenAnswer((_) => Stream.value(NowPlayingError('Error message')));
    when(() => nowPlayingBlocMovie.state)
        .thenReturn(NowPlayingError('Error message'));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(NowPlayingMoviesPage()));

    expect(textFinder, findsOneWidget);
  });
}
