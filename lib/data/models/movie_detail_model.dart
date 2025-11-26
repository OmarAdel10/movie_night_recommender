import 'package:equatable/equatable.dart';
import 'genre_model.dart';

class MovieDetail extends Equatable {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final String releaseDate;
  final int runtime;
  final List<Genre> genres;
  final List<Cast> cast;
  final String tagline;
  final int budget;
  final int revenue;

  const MovieDetail({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    this.runtime = 0,
    this.genres = const [],
    this.cast = const [],
    this.tagline = '',
    this.budget = 0,
    this.revenue = 0,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      releaseDate: json['release_date'] ?? '',
      runtime: json['runtime'] ?? 0,
      genres: (json['genres'] as List?)
              ?.map((e) => Genre.fromJson(e))
              .toList() ??
          const [],
      cast: [], // Cast comes from credits endpoint
      tagline: json['tagline'] ?? '',
      budget: json['budget'] ?? 0,
      revenue: json['revenue'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        overview,
        posterPath,
        backdropPath,
        voteAverage,
        releaseDate,
        runtime,
        genres,
        cast,
        tagline,
        budget,
        revenue,
      ];
}

class Cast extends Equatable {
  final int id;
  final String name;
  final String character;
  final String profilePath;

  const Cast({
    required this.id,
    required this.name,
    required this.character,
    required this.profilePath,
  });

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      character: json['character'] ?? '',
      profilePath: json['profile_path'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name, character, profilePath];
}
