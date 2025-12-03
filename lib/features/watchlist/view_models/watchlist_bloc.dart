import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/movie_model.dart';
import '../../auth/view_models/auth_bloc.dart';
import '../data/repositories/watchlist_repository.dart';

part 'watchlist_event.dart';
part 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  final WatchlistRepository _watchlistRepository;
  final AuthBloc _authBloc;
  StreamSubscription? _authSubscription;
  StreamSubscription? _watchlistSubscription;

  WatchlistBloc({
    required WatchlistRepository watchlistRepository,
    required AuthBloc authBloc,
  })  : _watchlistRepository = watchlistRepository,
        _authBloc = authBloc,
        super(const WatchlistState()) {
    on<WatchlistMovieAdded>(_onWatchlistMovieAdded);
    on<WatchlistMovieRemoved>(_onWatchlistMovieRemoved);
    on<WatchlistMovieToggled>(_onWatchlistMovieToggled);
    on<WatchlistUpdated>(_onWatchlistUpdated);
    on<WatchlistClearRequested>(_onWatchlistClearRequested);

    _authSubscription = _authBloc.stream.listen((authState) {
      if (authState.status == AuthStatus.authenticated) {
        _subscribeToWatchlist(authState.user!.uid);
      } else {
        add(WatchlistClearRequested());
        _watchlistSubscription?.cancel();
      }
    });
    
    // Initialize if already authenticated
    if (_authBloc.state.status == AuthStatus.authenticated) {
      _subscribeToWatchlist(_authBloc.state.user!.uid);
    }
  }

  void _subscribeToWatchlist(String userId) {
    _watchlistSubscription?.cancel();
    _watchlistSubscription = _watchlistRepository.getWatchlist(userId).listen(
      (movies) => add(WatchlistUpdated(movies)),
    );
  }

  void _onWatchlistUpdated(
    WatchlistUpdated event,
    Emitter<WatchlistState> emit,
  ) {
    emit(state.copyWith(movies: event.movies));
  }

  void _onWatchlistClearRequested(
    WatchlistClearRequested event,
    Emitter<WatchlistState> emit,
  ) {
    emit(const WatchlistState(movies: []));
  }

  Future<void> _onWatchlistMovieAdded(
    WatchlistMovieAdded event,
    Emitter<WatchlistState> emit,
  ) async {
    final user = _authBloc.state.user;
    if (user != null) {
      await _watchlistRepository.addMovie(user.uid, event.movie);
    }
  }

  Future<void> _onWatchlistMovieRemoved(
    WatchlistMovieRemoved event,
    Emitter<WatchlistState> emit,
  ) async {
    final user = _authBloc.state.user;
    if (user != null) {
      await _watchlistRepository.removeMovie(user.uid, event.movieId);
    }
  }

  Future<void> _onWatchlistMovieToggled(
    WatchlistMovieToggled event,
    Emitter<WatchlistState> emit,
  ) async {
    final user = _authBloc.state.user;
    if (user != null) {
      if (state.isInWatchlist(event.movie.id)) {
        await _watchlistRepository.removeMovie(user.uid, event.movie.id);
      } else {
        await _watchlistRepository.addMovie(user.uid, event.movie);
      }
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    _watchlistSubscription?.cancel();
    return super.close();
  }
}
