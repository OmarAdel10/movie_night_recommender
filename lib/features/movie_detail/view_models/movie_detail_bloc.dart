import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/movie_detail_model.dart';
import '../../../data/repositories/movie_repository.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final MovieRepository _movieRepository;

  MovieDetailBloc({required MovieRepository movieRepository})
      : _movieRepository = movieRepository,
        super(const MovieDetailState()) {
    on<MovieDetailLoadRequested>(_onMovieDetailLoadRequested);
  }

  Future<void> _onMovieDetailLoadRequested(
    MovieDetailLoadRequested event,
    Emitter<MovieDetailState> emit,
  ) async {
    emit(state.copyWith(status: MovieDetailStatus.loading));
    try {
      final movieDetail = await _movieRepository.getMovieDetail(event.movieId);
      emit(state.copyWith(
        status: MovieDetailStatus.success,
        movieDetail: movieDetail,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: MovieDetailStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
