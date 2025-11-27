import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:movie_night_recommender/l10n/arb/app_localizations.dart';
import '../../settings/views/settings_screen.dart';
import '../../search/views/search_screen.dart';
import '../../watchlist/views/watchlist_screen.dart';
import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  static const String routeName = '/main';

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
    const WatchlistScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.transparent,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                backgroundColor: Colors.transparent,
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Theme.of(context).primaryColor,
                unselectedItemColor: Colors.grey,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                items: [
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.home_outlined),
                    activeIcon: const Icon(Icons.home),
                    label: l10n.homeTitle,
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.search),
                    activeIcon: const Icon(Icons.search),
                    label: l10n.search,
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.bookmark_border),
                    activeIcon: const Icon(Icons.bookmark),
                    label: l10n.watchlist,
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.settings_outlined),
                    activeIcon: const Icon(Icons.settings),
                    label: l10n.settings,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
