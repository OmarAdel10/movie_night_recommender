import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/movie_model.dart';

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
}
