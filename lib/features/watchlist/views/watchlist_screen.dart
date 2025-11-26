import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../view_models/watchlist_bloc.dart';

class WatchlistScreen extends StatelessWidget {
  static const String routeName = '/watchlist';

  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Watchlist'),
      ),
      body: BlocBuilder<WatchlistBloc, WatchlistState>(
        builder: (context, state) {
          if (state.movies.isEmpty) {
            return _buildEmptyState(context);
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: state.movies.length,
            itemBuilder: (context, index) {
              final movie = state.movies[index];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    '/movie-detail',
                    arguments: {
                      'movieId': movie.id,
                      'heroTag': 'watchlist-movie-${movie.id}',
                    },
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Hero(
                            tag: 'watchlist-movie-${movie.id}',
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: movie.posterPath.isNotEmpty
                                  ? Image.network(
                                      'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey[900],
                                          child: const Icon(Icons.movie, size: 40),
                                        );
                                      },
                                    )
                                  : Container(
                                      color: Colors.grey[900],
                                      child: const Icon(Icons.movie, size: 40),
                                    ),
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: IconButton(
                              icon: const Icon(
                                Icons.remove_circle,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                context.read<WatchlistBloc>().add(
                                      WatchlistMovieRemoved(movie.id),
                                    );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      movie.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 14,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          movie.voteAverage.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_border,
            size: 64,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 16),
          Text(
            'Your watchlist is empty',
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add movies to your watchlist to see them here',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
