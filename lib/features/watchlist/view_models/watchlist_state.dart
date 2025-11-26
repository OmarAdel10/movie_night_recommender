part of 'watchlist_bloc.dart';

class WatchlistState extends Equatable {
  final List<Movie> movies;

  const WatchlistState({this.movies = const []});

  WatchlistState copyWith({List<Movie>? movies}) {
    return WatchlistState(movies: movies ?? this.movies);
  }

  Map<String, dynamic> toJson() {
    return {
      'movies': movies.map((m) => m.toJson()).toList(),
    };
  }

  factory WatchlistState.fromJson(Map<String, dynamic> json) {
    return WatchlistState(
      movies: (json['movies'] as List?)
              ?.map((e) => Movie.fromJson(e))
              .toList() ??
          const [],
    );
  }

  bool isInWatchlist(int movieId) {
    return movies.any((m) => m.id == movieId);
  }

  @override
  List<Object?> get props => [movies];
}
