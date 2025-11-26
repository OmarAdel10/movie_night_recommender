part of 'onboarding_bloc.dart';

class OnboardingState extends Equatable {
  final bool hasSeenOnboarding;
  final List<Genre> selectedGenres;
  final List<Genre> availableGenres;
  final bool isLoading;
  final String? errorMessage;

  const OnboardingState({
    this.hasSeenOnboarding = false,
    this.selectedGenres = const [],
    this.availableGenres = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  OnboardingState copyWith({
    bool? hasSeenOnboarding,
    List<Genre>? selectedGenres,
    List<Genre>? availableGenres,
    bool? isLoading,
    String? errorMessage,
  }) {
    return OnboardingState(
      hasSeenOnboarding: hasSeenOnboarding ?? this.hasSeenOnboarding,
      selectedGenres: selectedGenres ?? this.selectedGenres,
      availableGenres: availableGenres ?? this.availableGenres,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        hasSeenOnboarding,
        selectedGenres,
        availableGenres,
        isLoading,
        errorMessage,
      ];
  
  Map<String, dynamic> toJson() {
    return {
      'hasSeenOnboarding': hasSeenOnboarding,
      'selectedGenres': selectedGenres.map((e) => {'id': e.id, 'name': e.name}).toList(),
    };
  }

  factory OnboardingState.fromJson(Map<String, dynamic> json) {
    return OnboardingState(
      hasSeenOnboarding: json['hasSeenOnboarding'] ?? false,
      selectedGenres: (json['selectedGenres'] as List?)
              ?.map((e) => Genre.fromJson(e))
              .toList() ??
          const [],
    );
  }
}
