import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/ssl_pinning.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/bloc/detail_bloc_movie.dart';
import 'package:ditonton/presentation/bloc/detail_bloc_tv.dart';
import 'package:ditonton/presentation/bloc/now_playing_bloc_movie.dart';
import 'package:ditonton/presentation/bloc/now_playing_bloc_tv.dart';
import 'package:ditonton/presentation/bloc/popular_bloc_movie.dart';
import 'package:ditonton/presentation/bloc/popular_bloc_tv.dart';
import 'package:ditonton/presentation/bloc/top_rated_bloc_movie.dart';
import 'package:ditonton/presentation/bloc/top_rated_bloc_tv.dart';
import 'package:ditonton/presentation/bloc/search_bloc_movie.dart';
import 'package:ditonton/presentation/bloc/search_bloc_tv.dart';
import 'package:ditonton/presentation/bloc/watchlist_bloc_movie.dart';
import 'package:ditonton/presentation/bloc/watchlist_bloc_tv.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/now_playing_movies_page.dart';
import 'package:ditonton/presentation/pages/now_playing_tv_series_page.dart';
import 'package:ditonton/presentation/pages/search_tv_page.dart';
import 'package:ditonton/presentation/pages/tv_detail_page.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton/presentation/pages/home_tv_page.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/popular_tv_series_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_series_page.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:ditonton/presentation/pages/watchlist_tv_series_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/injection.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  await HttpSSLPinning.init();
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.locator<DetailBlocMovie>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SearchBlocMovie>(),
        ),
        BlocProvider(
          create: (_) =>
              di.locator<TopRatedBlocMovie>()..add(GetTopRatedMovie()),
        ),
        BlocProvider(
          create: (_) => di.locator<PopularBlocMovie>()..add(GetPopularMovie()),
        ),
        BlocProvider(
          create: (_) =>
              di.locator<NowPlayingBlocMovie>()..add(GetNowPlayingMovie()),
        ),
        BlocProvider(
          create: (_) =>
              di.locator<WatchlistBlocMovie>()..add(GetWatchlistMovie()),
        ),
        BlocProvider(
          create: (_) => di.locator<DetailBlocTv>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SearchBlocTv>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TopRatedBlocTv>()..add(GetTopRatedTv()),
        ),
        BlocProvider(
          create: (_) => di.locator<PopularBlocTv>()..add(GetPopularTv()),
        ),
        BlocProvider(
          create: (_) => di.locator<NowPlayingBlocTv>()..add(GetNowPlayingTv()),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistBlocTv>()..add(GetWatchlistTv()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
        ),
        home: HomeMoviePage(),
        // For FirebaseCrashlytics
        // home: TextButton(
        //   onPressed: () => FirebaseCrashlytics.instance.crash(),
        //   child: const Text("Throw Test Exception"),
        // ),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => HomeMoviePage());
            case HomeTvPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => HomeTvPage());
            case NowPlayingMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => NowPlayingMoviesPage());
            case NowPlayingTvSeriesPage.ROUTE_NAME:
              return CupertinoPageRoute(
                  builder: (_) => NowPlayingTvSeriesPage());
            case PopularMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case PopularTvSeriesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularTvSeriesPage());
            case TopRatedMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case TopRatedTvSeriesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedTvSeriesPage());
            case MovieDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case TvDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvDetailPage(id: id),
                settings: settings,
              );
            case SearchPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchPage());
            case SearchTvPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchTvPage());
            case WatchlistPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistPage());
            case WatchlistMoviesPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());
            case WatchlistTvSeriesPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistTvSeriesPage());
            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => AboutPage());
            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
