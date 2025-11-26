part of 'search_bloc.dart';

enum SearchStatus { initial, loading, success, failure }

class SearchState extends Equatable {
  final SearchStatus status;
  final List<Movie> results;
  final String query;
  final String? errorMessage;

  const SearchState({
    this.status = SearchStatus.initial,
    this.results = const [],
    this.query = '',
    this.errorMessage,
  });

  SearchState copyWith({
    SearchStatus? status,
    List<Movie>? results,
    String? query,
    String? errorMessage,
  }) {
    return SearchState(
      status: status ?? this.status,
      results: results ?? this.results,
      query: query ?? this.query,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, results, query, errorMessage];
}
