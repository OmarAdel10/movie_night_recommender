import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/movie_model.dart';
import '../../../data/repositories/movie_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final MovieRepository _movieRepository;

  SearchBloc({required MovieRepository movieRepository})
      : _movieRepository = movieRepository,
        super(const SearchState()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<SearchQueryCleared>(_onSearchQueryCleared);
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(const SearchState());
      return;
    }

    emit(state.copyWith(status: SearchStatus.loading, query: event.query));
    
    try {
      final results = await _movieRepository.searchMovies(event.query);
      emit(state.copyWith(
        status: SearchStatus.success,
        results: results,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SearchStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onSearchQueryCleared(
    SearchQueryCleared event,
    Emitter<SearchState> emit,
  ) {
    emit(const SearchState());
  }
}
