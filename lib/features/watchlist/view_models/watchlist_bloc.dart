import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/movie_model.dart';

part 'watchlist_event.dart';
part 'watchlist_state.dart';

class WatchlistBloc extends HydratedBloc<WatchlistEvent, WatchlistState> {
  WatchlistBloc() : super(const WatchlistState()) {
    on<WatchlistMovieAdded>(_onWatchlistMovieAdded);
    on<WatchlistMovieRemoved>(_onWatchlistMovieRemoved);
    on<WatchlistMovieToggled>(_onWatchlistMovieToggled);
  }

  void _onWatchlistMovieAdded(
    WatchlistMovieAdded event,
    Emitter<WatchlistState> emit,
  ) {
    if (!state.isInWatchlist(event.movie.id)) {
      emit(state.copyWith(movies: [...state.movies, event.movie]));
    }
  }

  void _onWatchlistMovieRemoved(
    WatchlistMovieRemoved event,
    Emitter<WatchlistState> emit,
  ) {
    emit(state.copyWith(
      movies: state.movies.where((m) => m.id != event.movieId).toList(),
    ));
  }

  void _onWatchlistMovieToggled(
    WatchlistMovieToggled event,
    Emitter<WatchlistState> emit,
  ) {
    if (state.isInWatchlist(event.movie.id)) {
      emit(state.copyWith(
        movies: state.movies.where((m) => m.id != event.movie.id).toList(),
      ));
    } else {
      emit(state.copyWith(movies: [...state.movies, event.movie]));
    }
  }

  @override
  WatchlistState? fromJson(Map<String, dynamic> json) {
    try {
      return WatchlistState.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(WatchlistState state) {
    try {
      return state.toJson();
    } catch (_) {
      return null;
    }
  }
}
