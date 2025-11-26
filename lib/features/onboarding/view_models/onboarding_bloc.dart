import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/genre_model.dart';
import '../../../data/repositories/movie_repository.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends HydratedBloc<OnboardingEvent, OnboardingState> {
  final MovieRepository _movieRepository;

  OnboardingBloc({required MovieRepository movieRepository})
      : _movieRepository = movieRepository,
        super(const OnboardingState()) {
    on<OnboardingStarted>(_onOnboardingStarted);
    on<OnboardingCompleted>(_onOnboardingCompleted);
    on<OnboardingGenreSelected>(_onOnboardingGenreSelected);
    on<OnboardingGenreDeselected>(_onOnboardingGenreDeselected);
  }

  Future<void> _onOnboardingStarted(
    OnboardingStarted event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final genres = await _movieRepository.getGenres();
      emit(state.copyWith(
        availableGenres: genres,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onOnboardingCompleted(
    OnboardingCompleted event,
    Emitter<OnboardingState> emit,
  ) {
    emit(state.copyWith(hasSeenOnboarding: true));
  }

  void _onOnboardingGenreSelected(
    OnboardingGenreSelected event,
    Emitter<OnboardingState> emit,
  ) {
    final updatedGenres = List<Genre>.from(state.selectedGenres)..add(event.genre);
    emit(state.copyWith(selectedGenres: updatedGenres));
  }

  void _onOnboardingGenreDeselected(
    OnboardingGenreDeselected event,
    Emitter<OnboardingState> emit,
  ) {
    final updatedGenres = List<Genre>.from(state.selectedGenres)..remove(event.genre);
    emit(state.copyWith(selectedGenres: updatedGenres));
  }

  @override
  OnboardingState? fromJson(Map<String, dynamic> json) {
    return OnboardingState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(OnboardingState state) {
    return state.toJson();
  }
}
