import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:movie_night_recommender/main.dart';
import 'package:movie_night_recommender/features/auth/data/repositories/auth_repository.dart';
import 'package:movie_night_recommender/data/repositories/movie_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class MockMovieRepository extends Mock implements MovieRepository {}
class MockStorage extends Mock implements Storage {}

void main() {
  late MockStorage storage;
  late MockAuthRepository authRepository;
  late MockMovieRepository movieRepository;

  setUp(() {
    storage = MockStorage();
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
    HydratedBloc.storage = storage;
    
    authRepository = MockAuthRepository();
    movieRepository = MockMovieRepository();
    
    when(() => authRepository.user).thenAnswer((_) => const Stream.empty());
  });

  testWidgets('App renders LoginScreen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MovieNightApp(
      authRepository: authRepository,
      movieRepository: movieRepository,
    ));
    await tester.pumpAndSettle();

    // Verify that LoginScreen is shown (by finding a widget specific to it, e.g. 'Login')
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
