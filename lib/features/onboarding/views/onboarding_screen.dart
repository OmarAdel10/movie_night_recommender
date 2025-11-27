import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../data/repositories/movie_repository.dart';
import '../view_models/onboarding_bloc.dart';
import '../../auth/views/login_screen.dart';

class OnboardingScreen extends StatelessWidget {
  static const String routeName = '/onboarding';

  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingBloc(
        movieRepository: context.read<MovieRepository>(),
      )..add(OnboardingStarted()),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatefulWidget {
  const _OnboardingView();

  @override
  State<_OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<_OnboardingView> {
  final PageController _pageController = PageController();
  bool _isLastPage = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: BlocConsumer<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          if (state.hasSeenOnboarding) {
            Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Stack(
              children: [
                PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _isLastPage = index == 2;
                    });
                  },
                  children: [
                    _buildPage(
                      title: 'Welcome to Movie Night',
                      description: 'Discover your next favorite movie with personalized recommendations.',
                      image: Icons.movie_filter_outlined,
                      theme: theme,
                    ),
                    _buildPage(
                      title: 'Curated for You',
                      description: 'Get recommendations based on your taste and what you love.',
                      image: Icons.recommend_outlined,
                      theme: theme,
                    ),
                    _buildCategorySelectionPage(context, state, theme),
                  ],
                ),
                Container(
                  alignment: const Alignment(0, 0.85),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Skip Button
                      if (!_isLastPage)
                        TextButton(
                          onPressed: () {
                            _pageController.jumpToPage(2);
                          },
                          child: const Text('SKIP'),
                        )
                      else
                        const SizedBox(width: 60), // Placeholder for spacing
                      // Indicator
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: 3,
                        effect: WormEffect(
                          activeDotColor: theme.primaryColor,
                          dotColor: Colors.grey.shade800,
                          dotHeight: 10,
                          dotWidth: 10,
                        ),
                      ),

                      // Next/Done Button
                      if (!_isLastPage)
                        TextButton(
                          onPressed: () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn,
                            );
                          },
                          child: const Text('NEXT'),
                        )
                      else
                        TextButton(
                          onPressed: () {
                            context.read<OnboardingBloc>().add(OnboardingCompleted());
                          },
                          child: const Text('DONE'),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPage({
    required String title,
    required String description,
    required IconData image,
    required ThemeData theme,
  }) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            image,
            size: 150,
            color: theme.primaryColor,
          ),
          const SizedBox(height: 32),
          Text(
            title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelectionPage(
    BuildContext context,
    OnboardingState state,
    ThemeData theme,
  ) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null) {
      return Center(child: Text('Error: ${state.errorMessage}'));
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Choose Your Favorites',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Select genres you love to help us recommend better movies.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                alignment: WrapAlignment.center,
                children: state.availableGenres.map((genre) {
                  final isSelected = state.selectedGenres.contains(genre);
                  return FilterChip(
                    label: Text(genre.name),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        context.read<OnboardingBloc>().add(OnboardingGenreSelected(genre));
                      } else {
                        context.read<OnboardingBloc>().add(OnboardingGenreDeselected(genre));
                      }
                    },
                    backgroundColor: Colors.grey.shade900,
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 80), // Space for bottom controls
        ],
      ),
    );
  }
}
