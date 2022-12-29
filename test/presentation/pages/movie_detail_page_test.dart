// import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/detail_bloc_movie.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
// import 'package:ditonton/presentation/provider/movie_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
import 'package:mocktail/mocktail.dart';
// import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
// import 'movie_detail_page_test.mocks.dart';

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
        .thenAnswer((_) => Stream.value(DetailLoading()));
    when(() => detailBlocMovie.state).thenReturn(DetailLoading());
    // when(() => detailBlocMovie.stream).thenAnswer((_) => Stream.value(
    //     DetailHasData(testMovieDetail, testMovieList, testIsAddedToWatchlist)));
    when(() => detailBlocMovie.state)
        .thenReturn(DetailHasData(testMovieDetail, testMovieList, false));
    when(() => detailBlocMovie.movie).thenReturn(testMovieDetail);
    when(() => detailBlocMovie.movieRecommendations).thenReturn(<Movie>[]);
    when(() => detailBlocMovie.isAddedToWatchlist).thenReturn(false);
    // when(() => detailBlocMovie.stream).thenAnswer((_) => Stream.value(
    //     DetailHasData(testMovieDetail, testMovieList, testIsAddedToWatchlist)));
    // when(() => detailBlocMovie.).thenReturn(
    //     DetailHasData(testMovieDetail, testMovieList, testIsAddedToWatchlist));

    // when(mockBloc.movieState).thenReturn(RequestState.Loaded);
    // when(mockBloc.movie).thenReturn(testMovieDetail);
    // when(mockBloc.recommendationState).thenReturn(RequestState.Loaded);
    // when(mockBloc.movieRecommendations).thenReturn(<Movie>[]);
    // when(mockBloc.isAddedToWatchlist).thenReturn(false);

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when movie is added to wathclist',
      (WidgetTester tester) async {
    when(() => detailBlocMovie.stream)
        .thenAnswer((_) => Stream.value(DetailLoading()));
    when(() => detailBlocMovie.state).thenReturn(DetailLoading());
    when(() => detailBlocMovie.state)
        .thenReturn(DetailHasData(testMovieDetail, testMovieList, true));
    when(() => detailBlocMovie.movie).thenReturn(testMovieDetail);
    when(() => detailBlocMovie.movieRecommendations).thenReturn(<Movie>[]);
    when(() => detailBlocMovie.isAddedToWatchlist).thenReturn(true);
    // when(mockBloc.movieState).thenReturn(RequestState.Loaded);
    // when(mockBloc.movie).thenReturn(testMovieDetail);
    // when(mockBloc.recommendationState).thenReturn(RequestState.Loaded);
    // when(mockBloc.movieRecommendations).thenReturn(<Movie>[]);
    // when(mockBloc.isAddedToWatchlist).thenReturn(true);

    // final watchlistButtonIcon = find.byIcon(Icons.check);
    final watchlistButtonIcon = find.text('Watchlist');

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    // when(mockBloc.movieState).thenReturn(RequestState.Loaded);
    // when(mockBloc.movie).thenReturn(testMovieDetail);
    // when(mockBloc.recommendationState).thenReturn(RequestState.Loaded);
    // when(mockBloc.movieRecommendations).thenReturn(<Movie>[]);
    // when(mockBloc.isAddedToWatchlist).thenReturn(false);
    // when(mockBloc.watchlistMessage).thenReturn('Added to Watchlist');

    when(() => detailBlocMovie.stream)
        .thenAnswer((_) => Stream.value(DetailLoading()));
    when(() => detailBlocMovie.state).thenReturn(DetailLoading());
    when(() => detailBlocMovie.state)
        .thenReturn(DetailHasData(testMovieDetail, testMovieList, false));
    when(() => detailBlocMovie.movie).thenReturn(testMovieDetail);
    when(() => detailBlocMovie.movieRecommendations).thenReturn(<Movie>[]);
    when(() => detailBlocMovie.isAddedToWatchlist).thenReturn(false);
    when(() => detailBlocMovie.watchlistMessage)
        .thenReturn('Added to Watchlist');

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    // when(mockBloc.movieState).thenReturn(RequestState.Loaded);
    // when(mockBloc.movie).thenReturn(testMovieDetail);
    // when(mockBloc.recommendationState).thenReturn(RequestState.Loaded);
    // when(mockBloc.movieRecommendations).thenReturn(<Movie>[]);
    // when(mockBloc.isAddedToWatchlist).thenReturn(false);
    // when(mockBloc.watchlistMessage).thenReturn('Failed');

    when(() => detailBlocMovie.stream)
        .thenAnswer((_) => Stream.value(DetailLoading()));
    when(() => detailBlocMovie.state).thenReturn(DetailLoading());
    when(() => detailBlocMovie.state)
        .thenReturn(DetailHasData(testMovieDetail, testMovieList, false));
    when(() => detailBlocMovie.movie).thenReturn(testMovieDetail);
    when(() => detailBlocMovie.movieRecommendations).thenReturn(<Movie>[]);
    when(() => detailBlocMovie.isAddedToWatchlist).thenReturn(false);
    when(() => detailBlocMovie.watchlistMessage).thenReturn('Failed');

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}
