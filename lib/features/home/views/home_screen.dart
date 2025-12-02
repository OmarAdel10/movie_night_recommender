import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_night_recommender/l10n/arb/app_localizations.dart';
import 'package:shimmer/shimmer.dart';
import '../../../data/repositories/movie_repository.dart';
import '../view_models/home_bloc.dart';
import 'widgets/movie_carousel.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(
        movieRepository: context.read<MovieRepository>(),
      )..add(HomeLoadMovies()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.status == HomeStatus.loading || state.status == HomeStatus.initial) {
          return _buildLoadingShimmer();
        }

        if (state.status == HomeStatus.failure) {
          return _buildError(context, state.errorMessage ?? 'Unknown error');
        }

        return RefreshIndicator(
          onRefresh: () async {
            context.read<HomeBloc>().add(HomeRefreshMovies());
            await Future.delayed(const Duration(seconds: 1));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                
                // Trending Movies
                if (state.trendingMovies.isNotEmpty)
                  MovieCarousel(
                    title: l10n.trendingNow,
                    movies: state.trendingMovies,
                  ),
                
                const SizedBox(height: 24),
                
                // Popular Movies
                if (state.popularMovies.isNotEmpty)
                  MovieCarousel(
                    title: l10n.popular,
                    movies: state.popularMovies,
                  ),
                
                const SizedBox(height: 24),
                
                // Top Rated Movies
                if (state.topRatedMovies.isNotEmpty)
                  MovieCarousel(
                    title: l10n.topRated,
                    movies: state.topRatedMovies,
                  ),
                
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.15), // Bottom padding for floating nav bar
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingShimmer() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildCarouselShimmer(),
          const SizedBox(height: 24),
          _buildCarouselShimmer(),
          const SizedBox(height: 24),
          _buildCarouselShimmer(),
        ],
      ),
    );
  }

  Widget _buildCarouselShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[900]!,
            highlightColor: Colors.grey[800]!,
            child: Container(
              width: 120,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                width: 130,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[900]!,
                        highlightColor: Colors.grey[800]!,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[900]!,
                      highlightColor: Colors.grey[800]!,
                      child: Container(
                        width: double.infinity,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildError(BuildContext context, String message) {
        final l10n = AppLocalizations.of(context)!;

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
              l10n.oopsSomethingWentWrong,
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
                context.read<HomeBloc>().add(HomeLoadMovies());
              },
              child: Text(l10n.tryAgain),
            ),
          ],
        ),
      ),
    );
  }
}
