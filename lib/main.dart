import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:page_transition/page_transition.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/repositories/auth_repository.dart';
import 'features/auth/view_models/auth_bloc.dart';
import 'features/auth/views/login_screen.dart';
import 'features/auth/views/sign_up_screen.dart';
import 'features/auth/views/forgot_password_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? null
        : await getApplicationDocumentsDirectory(),
  );

  final authRepository = AuthRepository();

  runApp(MovieNightApp(authRepository: authRepository));
}

class MovieNightApp extends StatelessWidget {
  final AuthRepository authRepository;

  const MovieNightApp({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authRepository,
      child: BlocProvider(
        create: (_) => AuthBloc(authRepository: authRepository),
        child: MaterialApp(
          title: 'Movie Night Recommender',
          theme: AppTheme.darkTheme,
          debugShowCheckedModeBanner: false,
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
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/':
                return PageTransition(
                  child: const LoginScreen(), // Start with Login for now
                  type: PageTransitionType.fade,
                  settings: settings,
                );
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
              default:
                return null;
            }
          },
        ),
      ),
    );
  }
}
