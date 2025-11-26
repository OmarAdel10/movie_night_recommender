import '../../core/network/api_client.dart';
import '../models/movie_model.dart';
import '../models/genre_model.dart';
import '../models/movie_detail_model.dart';

class MovieRepository {
  final ApiClient _apiClient;

  MovieRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<List<Movie>> getTrendingMovies() async {
    try {
      final response = await _apiClient.get('/trending/movie/week');
      final results = response.data['results'] as List;
      return results.map((e) => Movie.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load trending movies');
    }
  }

  Future<List<Movie>> getPopularMovies() async {
    try {
      final response = await _apiClient.get('/movie/popular');
      final results = response.data['results'] as List;
      return results.map((e) => Movie.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load popular movies');
    }
  }

  Future<List<Movie>> getTopRatedMovies() async {
    try {
      final response = await _apiClient.get('/movie/top_rated');
      final results = response.data['results'] as List;
      return results.map((e) => Movie.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load top rated movies');
    }
  }

  Future<List<Genre>> getGenres() async {
    try {
      final response = await _apiClient.get('/genre/movie/list');
      final results = response.data['genres'] as List;
      return results.map((e) => Genre.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load genres');
    }
  }

  Future<MovieDetail> getMovieDetail(int movieId) async {
    try {
      final response = await _apiClient.get('/movie/$movieId');
      final creditsResponse = await _apiClient.get('/movie/$movieId/credits');
      
      final movieDetail = MovieDetail.fromJson(response.data);
      final castList = (creditsResponse.data['cast'] as List?)
              ?.take(10)
              .map((e) => Cast.fromJson(e))
              .toList() ??
          const [];
      
      // Return movieDetail with cast
      return MovieDetail(
        id: movieDetail.id,
        title: movieDetail.title,
        overview: movieDetail.overview,
        posterPath: movieDetail.posterPath,
        backdropPath: movieDetail.backdropPath,
        voteAverage: movieDetail.voteAverage,
        releaseDate: movieDetail.releaseDate,
        runtime: movieDetail.runtime,
        genres: movieDetail.genres,
        cast: castList,
        tagline: movieDetail.tagline,
        budget: movieDetail.budget,
        revenue: movieDetail.revenue,
      );
    } catch (e) {
      throw Exception('Failed to load movie details');
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    try {
      final response = await _apiClient.get('/search/movie', queryParameters: {
        'query': query,
      });
      final results = response.data['results'] as List;
      return results.map((e) => Movie.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to search movies');
    }
  }

  Future<List<Movie>> getMoviesByGenre(int genreId) async {
    try {
      final response = await _apiClient.get('/discover/movie', queryParameters: {
        'with_genres': genreId.toString(),
        'sort_by': 'popularity.desc',
      });
      final results = response.data['results'] as List;
      return results.map((e) => Movie.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load movies by genre');
    }
  }
}
