part of 'onboarding_bloc.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object> get props => [];
}

class OnboardingStarted extends OnboardingEvent {}

class OnboardingCompleted extends OnboardingEvent {}

class OnboardingGenreSelected extends OnboardingEvent {
  final Genre genre;

  const OnboardingGenreSelected(this.genre);

  @override
  List<Object> get props => [genre];
}

class OnboardingGenreDeselected extends OnboardingEvent {
  final Genre genre;

  const OnboardingGenreDeselected(this.genre);

  @override
  List<Object> get props => [genre];
}
