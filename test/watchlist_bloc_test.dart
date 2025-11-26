import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:movie_night_recommender/features/watchlist/view_models/watchlist_bloc.dart';
import 'package:movie_night_recommender/data/models/movie_model.dart';

class MockStorage extends Mock implements Storage {}

void main() {
  group('WatchlistBloc', () {
    late WatchlistBloc watchlistBloc;
    late MockStorage storage;

    setUp(() {
      storage = MockStorage();
      when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
      HydratedBloc.storage = storage;
      watchlistBloc = WatchlistBloc();
    });

    tearDown(() {
      watchlistBloc.close();
    });

    test('initial state is empty', () {
      expect(watchlistBloc.state.movies, isEmpty);
    });

    group('WatchlistMovieAdded', () {
      final testMovie = Movie(
        id: 1,
        title: 'Test Movie',
        overview: 'Test Overview',
        posterPath: '/test.jpg',
        backdropPath: '/backdrop.jpg',
        voteAverage: 8.5,
        releaseDate: '2024-01-01',
      );

      blocTest<WatchlistBloc, WatchlistState>(
        'emits state with added movie',
        build: () => WatchlistBloc(),
        act: (bloc) => bloc.add(WatchlistMovieAdded(testMovie)),
        expect: () => [
          WatchlistState(movies: [testMovie]),
        ],
      );

      blocTest<WatchlistBloc, WatchlistState>(
        'does not add duplicate movie',
        build: () => WatchlistBloc(),
        seed: () => WatchlistState(movies: [testMovie]),
        act: (bloc) => bloc.add(WatchlistMovieAdded(testMovie)),
        expect: () => [],
      );
    });

    group('WatchlistMovieRemoved', () {
      final testMovie = Movie(
        id: 1,
        title: 'Test Movie',
        overview: 'Test Overview',
        posterPath: '/test.jpg',
        backdropPath: '/backdrop.jpg',
        voteAverage: 8.5,
        releaseDate: '2024-01-01',
      );

      blocTest<WatchlistBloc, WatchlistState>(
        'emits state with movie removed',
        build: () => WatchlistBloc(),
        seed: () => WatchlistState(movies: [testMovie]),
        act: (bloc) => bloc.add(WatchlistMovieRemoved(1)),
        expect: () => [
          const WatchlistState(movies: []),
        ],
      );
    });

    group('WatchlistMovieToggled', () {
      final testMovie = Movie(
        id: 1,
        title: 'Test Movie',
        overview: 'Test Overview',
        posterPath: '/test.jpg',
        backdropPath: '/backdrop.jpg',
        voteAverage: 8.5,
        releaseDate: '2024-01-01',
      );

      blocTest<WatchlistBloc, WatchlistState>(
        'adds movie when not in watchlist',
        build: () => WatchlistBloc(),
        act: (bloc) => bloc.add(WatchlistMovieToggled(testMovie)),
        expect: () => [
          WatchlistState(movies: [testMovie]),
        ],
      );

      blocTest<WatchlistBloc, WatchlistState>(
        'removes movie when already in watchlist',
        build: () => WatchlistBloc(),
        seed: () => WatchlistState(movies: [testMovie]),
        act: (bloc) => bloc.add(WatchlistMovieToggled(testMovie)),
        expect: () => [
          const WatchlistState(movies: []),
        ],
      );
    });

    group('Persistence', () {
      test('toJson serializes state correctly', () {
        final testMovie = Movie(
          id: 1,
          title: 'Test Movie',
          overview: 'Test Overview',
          posterPath: '/test.jpg',
          backdropPath: '/backdrop.jpg',
          voteAverage: 8.5,
          releaseDate: '2024-01-01',
        );

        final state = WatchlistState(movies: [testMovie]);
        final json = watchlistBloc.toJson(state);

        expect(json, isNotNull);
        expect(json!['movies'], isList);
        expect(json['movies'].length, 1);
      });

      test('fromJson deserializes state correctly', () {
        final json = {
          'movies': [
            {
              'id': 1,
              'title': 'Test Movie',
              'overview': 'Test Overview',
              'poster_path': '/test.jpg',
              'backdrop_path': '/backdrop.jpg',
              'vote_average': 8.5,
              'release_date': '2024-01-01',
            }
          ]
        };

        final state = watchlistBloc.fromJson(json);

        expect(state, isNotNull);
        expect(state!.movies.length, 1);
        expect(state.movies.first.title, 'Test Movie');
      });
    });

    group('isInWatchlist', () {
      final testMovie = Movie(
        id: 1,
        title: 'Test Movie',
        overview: 'Test Overview',
        posterPath: '/test.jpg',
        backdropPath: '/backdrop.jpg',
        voteAverage: 8.5,
        releaseDate: '2024-01-01',
      );

      test('returns true when movie is in watchlist', () {
        final state = WatchlistState(movies: [testMovie]);
        expect(state.isInWatchlist(1), isTrue);
      });

      test('returns false when movie is not in watchlist', () {
        const state = WatchlistState(movies: []);
        expect(state.isInWatchlist(1), isFalse);
      });
    });
  });
}
