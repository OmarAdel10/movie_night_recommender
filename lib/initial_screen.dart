import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_night_recommender/features/auth/view_models/auth_bloc.dart';
import 'package:movie_night_recommender/features/auth/views/login_screen.dart';
import 'package:movie_night_recommender/features/home/views/main_screen.dart';

class InitialScreen extends StatelessWidget {
  static const String routeName = '/initial';

  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, authState) {
        context.read<AuthBloc>().add(AuthCheckRequested());
        if (authState.status == AuthStatus.authenticated) {
          Navigator.of(context).pushReplacementNamed(MainScreen.routeName);
        } else if (authState.status == AuthStatus.unauthenticated) {
          Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
        }
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: MediaQuery.sizeOf(context).width * 0.5,
                height: MediaQuery.sizeOf(context).height * 0.5,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 16),
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
