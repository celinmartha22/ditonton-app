import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/detail_bloc_movie.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockDetailBlocMovie extends Mock implements DetailBlocMovie {}

class DetailEventMovieFake extends Fake implements DetailEventMovie {}

class DetailStateMovieFake extends Fake implements DetailStateMovie {}

void main() {
  late DetailBlocMovie detailBlocMovie;

  setUpAll(() {
    registerFallbackValue(DetailEventMovieFake());
    registerFallbackValue(DetailStateMovieFake());
  });

  setUp(() {
    detailBlocMovie = MockDetailBlocMovie();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<DetailBlocMovie>.value(
      value: detailBlocMovie,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(() => detailBlocMovie.stream)
        .thenAnswer((_) => Stream.value(DetailStateMovie.initial().copyWith(
              movieDetail: testMovieDetail,
              detailStateMovie: RequestState.Loaded,
              movieRecommendationsState: RequestState.Loaded,
              isAddedToWatchlist: false,
            )));
    when(() => detailBlocMovie.state)
        .thenReturn(DetailStateMovie.initial().copyWith(
      movieDetail: testMovieDetail,
      detailStateMovie: RequestState.Loaded,
      movieRecommendationsState: RequestState.Loaded,
      isAddedToWatchlist: false,
    ));

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when movie is added to wathclist',
      (WidgetTester tester) async {
    when(() => detailBlocMovie.stream)
        .thenAnswer((_) => Stream.value(DetailStateMovie.initial().copyWith(
              movieDetail: testMovieDetail,
              detailStateMovie: RequestState.Loaded,
              movieRecommendationsState: RequestState.Loaded,
              isAddedToWatchlist: true,
            )));
    when(() => detailBlocMovie.state)
        .thenReturn(DetailStateMovie.initial().copyWith(
      movieDetail: testMovieDetail,
      detailStateMovie: RequestState.Loaded,
      movieRecommendationsState: RequestState.Loaded,
      isAddedToWatchlist: true,
    ));

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    when(() => detailBlocMovie.stream)
        .thenAnswer((_) => Stream.value(DetailStateMovie.initial().copyWith(
              movieDetail: testMovieDetail,
              detailStateMovie: RequestState.Loaded,
              movieRecommendationsState: RequestState.Loaded,
              isAddedToWatchlist: false,
            )));
    when(() => detailBlocMovie.state)
        .thenReturn(DetailStateMovie.initial().copyWith(
      movieDetail: testMovieDetail,
      detailStateMovie: RequestState.Loaded,
      movieRecommendationsState: RequestState.Loaded,
      isAddedToWatchlist: false,
    ));
    when(() => detailBlocMovie.add(AddWatchlist(testMovieDetail)))
        .thenAnswer((_) async => {});

    whenListen(
        detailBlocMovie,
        Stream.fromIterable([
          detailBlocMovie.state.copyWith(watchlistMessage: 'Added to Watchlist')
        ]));

    final watchlistButton = find.byType(ElevatedButton);
    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

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
    when(() => detailBlocMovie.stream)
        .thenAnswer((_) => Stream.value(DetailStateMovie.initial().copyWith(
              movieDetail: testMovieDetail,
              detailStateMovie: RequestState.Loaded,
              movieRecommendationsState: RequestState.Loaded,
              isAddedToWatchlist: false,
            )));
    when(() => detailBlocMovie.state)
        .thenReturn(DetailStateMovie.initial().copyWith(
      movieDetail: testMovieDetail,
      detailStateMovie: RequestState.Loaded,
      movieRecommendationsState: RequestState.Loaded,
      isAddedToWatchlist: false,
    ));

    when(() => detailBlocMovie.add(AddWatchlist(testMovieDetail)))
        .thenAnswer((_) async => {});

    whenListen(
        detailBlocMovie,
        Stream.fromIterable(
            [detailBlocMovie.state.copyWith(watchlistMessage: 'Failed')]));

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}
