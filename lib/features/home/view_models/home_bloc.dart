import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/movie_model.dart';
import '../../../data/repositories/movie_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final MovieRepository _movieRepository;

  HomeBloc({required MovieRepository movieRepository})
      : _movieRepository = movieRepository,
        super(const HomeState()) {
    on<HomeLoadMovies>(_onHomeLoadMovies);
    on<HomeRefreshMovies>(_onHomeRefreshMovies);
  }

  Future<void> _onHomeLoadMovies(
    HomeLoadMovies event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final trending = await _movieRepository.getTrendingMovies();
      final popular = await _movieRepository.getPopularMovies();
      final topRated = await _movieRepository.getTopRatedMovies();

      emit(state.copyWith(
        status: HomeStatus.success,
        trendingMovies: trending,
        popularMovies: popular,
        topRatedMovies: topRated,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HomeStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onHomeRefreshMovies(
    HomeRefreshMovies event,
    Emitter<HomeState> emit,
  ) async {
    // Reuse load logic for refresh
    add(HomeLoadMovies());
  }
}
