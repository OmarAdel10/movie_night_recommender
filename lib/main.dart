import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:movie_night_recommender/initial_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:movie_night_recommender/l10n/arb/app_localizations.dart';
import 'package:page_transition/page_transition.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/movie_repository.dart';
import 'features/auth/data/repositories/auth_repository.dart';
import 'features/auth/view_models/auth_bloc.dart';
import 'features/auth/views/login_screen.dart';
import 'features/auth/views/sign_up_screen.dart';
import 'features/auth/views/forgot_password_screen.dart';
import 'features/onboarding/view_models/onboarding_bloc.dart';
import 'features/onboarding/views/onboarding_screen.dart';
import 'features/home/views/main_screen.dart';
import 'features/movie_detail/views/movie_detail_screen.dart';
import 'features/watchlist/view_models/watchlist_bloc.dart';
import 'features/settings/view_models/settings_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getApplicationDocumentsDirectory()).path,
    ),
  );

  final AuthRepository authRepository = AuthRepository();
  final MovieRepository movieRepository = MovieRepository();

  runApp(
    MovieNightApp(
      authRepository: authRepository,
      movieRepository: movieRepository,
    ),
  );
}

class MovieNightApp extends StatelessWidget {
  final AuthRepository authRepository;
  final MovieRepository movieRepository;

  const MovieNightApp({
    super.key,
    required this.authRepository,
    required this.movieRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: movieRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthBloc(authRepository: authRepository)),
          BlocProvider(
            create: (_) => OnboardingBloc(movieRepository: movieRepository),
          ),
          BlocProvider(create: (_) => WatchlistBloc()),
          BlocProvider(create: (_) => SettingsBloc()),
        ],
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, settingsState) {
            return MaterialApp(
              title: 'Movie Night Recommender',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: settingsState.settings.themeMode,
              debugShowCheckedModeBanner: false,
              locale: settingsState.settings.locale,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en'), // English
                Locale('ar'), // Arabic
              ],
              // home: const RootScreen(),
              initialRoute: InitialScreen.routeName,
              onGenerateRoute: (settings) {
                switch (settings.name) {
                  case LoginScreen.routeName:
                    return PageTransition(
                      child: const LoginScreen(),
                      type: PageTransitionType.fade,
                      settings: settings,
                    );
                  case SignUpScreen.routeName:
                    return PageTransition(
                      child: const SignUpScreen(),
                      type: PageTransitionType.rightToLeft,
                      settings: settings,
                    );
                  case ForgotPasswordScreen.routeName:
                    return PageTransition(
                      child: const ForgotPasswordScreen(),
                      type: PageTransitionType.rightToLeft,
                      settings: settings,
                    );
                  case OnboardingScreen.routeName:
                    return PageTransition(
                      child: const OnboardingScreen(),
                      type: PageTransitionType.fade,
                      settings: settings,
                    );
                  case MainScreen.routeName:
                    return PageTransition(
                      child: const MainScreen(),
                      type: PageTransitionType.fade,
                      settings: settings,
                    );
                  case MovieDetailScreen.routeName:
                    final args = settings.arguments as Map<String, dynamic>;
                    return PageTransition(
                      child: MovieDetailScreen(
                        movieId: args['movieId'] as int,
                        // heroTag: args['heroTag'] as String?,
                      ),
                      type: PageTransitionType.rightToLeft,
                      settings: settings,
                    );
                  case InitialScreen.routeName:
                    return PageTransition(
                      child: const InitialScreen(),
                      type: PageTransitionType.fade,
                      settings: settings,
                    );
                  default:
                    return null;
                }
              },
            );
          },
        ),
      ),
    );
  }
}


