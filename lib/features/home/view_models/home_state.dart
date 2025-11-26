part of 'home_bloc.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<Movie> trendingMovies;
  final List<Movie> popularMovies;
  final List<Movie> topRatedMovies;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.trendingMovies = const [],
    this.popularMovies = const [],
    this.topRatedMovies = const [],
    this.errorMessage,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<Movie>? trendingMovies,
    List<Movie>? popularMovies,
    List<Movie>? topRatedMovies,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      trendingMovies: trendingMovies ?? this.trendingMovies,
      popularMovies: popularMovies ?? this.popularMovies,
      topRatedMovies: topRatedMovies ?? this.topRatedMovies,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        trendingMovies,
        popularMovies,
        topRatedMovies,
        errorMessage,
      ];
}
