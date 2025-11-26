part of 'movie_detail_bloc.dart';

enum MovieDetailStatus { initial, loading, success, failure }

class MovieDetailState extends Equatable {
  final MovieDetailStatus status;
  final MovieDetail? movieDetail;
  final String? errorMessage;

  const MovieDetailState({
    this.status = MovieDetailStatus.initial,
    this.movieDetail,
    this.errorMessage,
  });

  MovieDetailState copyWith({
    MovieDetailStatus? status,
    MovieDetail? movieDetail,
    String? errorMessage,
  }) {
    return MovieDetailState(
      status: status ?? this.status,
      movieDetail: movieDetail ?? this.movieDetail,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, movieDetail, errorMessage];
}
