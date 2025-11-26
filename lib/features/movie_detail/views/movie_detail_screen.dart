import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/repositories/movie_repository.dart';
import '../../../data/models/movie_detail_model.dart';
import '../../../data/models/movie_model.dart';
import '../../watchlist/view_models/watchlist_bloc.dart';
import '../view_models/movie_detail_bloc.dart';

class MovieDetailScreen extends StatelessWidget {
  static const String routeName = '/movie-detail';
  final int movieId;
  final String? heroTag;

  const MovieDetailScreen({
    super.key,
    required this.movieId,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovieDetailBloc(
        movieRepository: context.read<MovieRepository>(),
      )..add(MovieDetailLoadRequested(movieId)),
      child: _MovieDetailView(heroTag: heroTag),
    );
  }
}

class _MovieDetailView extends StatelessWidget {
  final String? heroTag;

  const _MovieDetailView({this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MovieDetailBloc, MovieDetailState>(
        builder: (context, state) {
          if (state.status == MovieDetailStatus.loading || 
              state.status == MovieDetailStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == MovieDetailStatus.failure) {
            return _buildError(context, state.errorMessage ?? 'Unknown error');
          }

          final movie = state.movieDetail!;
          return _buildContent(context, movie);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, MovieDetail movie) {
    final theme = Theme.of(context);
    
    return CustomScrollView(
      slivers: [
        // App Bar with Backdrop
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          actions: [
            BlocBuilder<WatchlistBloc, WatchlistState>(
              builder: (context, watchlistState) {
                final movie = context.read<MovieDetailBloc>().state.movieDetail;
                if (movie == null) return const SizedBox.shrink();
                
                final isInWatchlist = watchlistState.isInWatchlist(movie.id);
                
                return IconButton(
                  icon: Icon(
                    isInWatchlist ? Icons.bookmark : Icons.bookmark_border,
                  ),
                  onPressed: () {
                    context.read<WatchlistBloc>().add(
                      WatchlistMovieToggled(
                        Movie(
                          id: movie.id,
                          title: movie.title,
                          overview: movie.overview,
                          posterPath: movie.posterPath,
                          backdropPath: movie.backdropPath,
                          voteAverage: movie.voteAverage,
                          releaseDate: movie.releaseDate,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                if (movie.backdropPath.isNotEmpty)
                  CachedNetworkImage(
                    imageUrl: 'https://image.tmdb.org/t/p/original${movie.backdropPath}',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[900],
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[900],
                      child: const Icon(Icons.error),
                    ),
                  ),
                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        theme.scaffoldBackgroundColor,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Content
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Poster and Title Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Poster with Hero animation
                    if (movie.posterPath.isNotEmpty)
                      Hero(
                        tag: heroTag ?? 'movie-${movie.id}',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                            width: 120,
                            height: 180,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    const SizedBox(width: 16),
                    
                    // Title and Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.title,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (movie.tagline.isNotEmpty)
                            Text(
                              movie.tagline,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                              ),
                            ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: 20,
                                color: theme.primaryColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                movie.voteAverage.toStringAsFixed(1),
                                style: theme.textTheme.titleMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          if (movie.releaseDate.isNotEmpty)
                            Text(
                              movie.releaseDate.split('-')[0], // Year only
                              style: theme.textTheme.bodyMedium,
                            ),
                          const SizedBox(height: 4),
                          if (movie.runtime > 0)
                            Text(
                              '${movie.runtime} min',
                              style: theme.textTheme.bodyMedium,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Genres
                if (movie.genres.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: movie.genres.map((genre) {
                      return Chip(
                        label: Text(genre.name),
                        backgroundColor: theme.primaryColor.withValues(alpha: 0.2),
                        labelStyle: TextStyle(color: theme.primaryColor),
                      );
                    }).toList(),
                  ),
                
                const SizedBox(height: 24),
                
                // Overview
                Text(
                  'Overview',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  movie.overview,
                  style: theme.textTheme.bodyLarge,
                ),
                
                const SizedBox(height: 24),
                
                // Cast
                if (movie.cast.isNotEmpty) ...[
                  Text(
                    'Cast',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 140,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: movie.cast.length,
                      itemBuilder: (context, index) {
                        final castMember = movie.cast[index];
                        return _buildCastCard(castMember, theme);
                      },
                    ),
                  ),
                ],
                
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCastCard(Cast cast, ThemeData theme) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          ClipOval(
            child: cast.profilePath.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: 'https://image.tmdb.org/t/p/w200${cast.profilePath}',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[800],
                      child: const Icon(Icons.person),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[800],
                      child: const Icon(Icons.person),
                    ),
                  )
                : Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[800],
                    child: const Icon(Icons.person, size: 40),
                  ),
          ),
          const SizedBox(height: 8),
          Text(
            cast.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            cast.character,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load movie details',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
