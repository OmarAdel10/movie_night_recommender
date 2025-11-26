import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/movie_repository.dart';
import '../../../data/models/movie_model.dart';
import '../view_models/search_bloc.dart';

class SearchScreen extends StatelessWidget {
  static const String routeName = '/search';

  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(
        movieRepository: context.read<MovieRepository>(),
      ),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search movies...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey[400]),
          ),
          style: theme.textTheme.titleMedium,
          onChanged: (query) {
            context.read<SearchBloc>().add(SearchQueryChanged(query));
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              context.read<SearchBloc>().add(SearchQueryCleared());
            },
          ),
        ],
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state.status == SearchStatus.initial) {
            return _buildInitialState(context);
          }

          if (state.status == SearchStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == SearchStatus.failure) {
            return _buildError(context, state.errorMessage ?? 'Unknown error');
          }

          if (state.results.isEmpty) {
            return _buildNoResults(context);
          }

          return _buildResults(context, state.results);
        },
      ),
    );
  }

  Widget _buildInitialState(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 16),
          Text(
            'Search for movies',
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter a movie title to start',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.movie_filter_outlined,
            size: 64,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try different keywords',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(BuildContext context, List<Movie> results) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final movie = results[index];
        return _MovieGridCard(movie: movie);
      },
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
              'Search failed',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _MovieGridCard extends StatelessWidget {
  final Movie movie;

  const _MovieGridCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/movie-detail',
          arguments: {
            'movieId': movie.id,
            'heroTag': 'search-movie-${movie.id}',
          },
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Hero(
              tag: 'search-movie-${movie.id}',
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
          ),
          const SizedBox(height: 8),
          Text(
            movie.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.star,
                size: 14,
                color: theme.primaryColor,
              ),
              const SizedBox(width: 4),
              Text(
                movie.voteAverage.toStringAsFixed(1),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
