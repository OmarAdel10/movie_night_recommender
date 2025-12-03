part of 'watchlist_bloc.dart';

abstract class WatchlistEvent extends Equatable {
  const WatchlistEvent();

  @override
  List<Object> get props => [];
}

class WatchlistMovieAdded extends WatchlistEvent {
  final Movie movie;

  const WatchlistMovieAdded(this.movie);

  @override
  List<Object> get props => [movie];
}

class WatchlistMovieRemoved extends WatchlistEvent {
  final int movieId;

  const WatchlistMovieRemoved(this.movieId);

  @override
  List<Object> get props => [movieId];
}

class WatchlistMovieToggled extends WatchlistEvent {
  final Movie movie;

  const WatchlistMovieToggled(this.movie);

  @override
  List<Object> get props => [movie];
}

class WatchlistUpdated extends WatchlistEvent {
  final List<Movie> movies;

  const WatchlistUpdated(this.movies);

  @override
  List<Object> get props => [movies];
}

class WatchlistClearRequested extends WatchlistEvent {
  @override
  List<Object> get props => [];
}
