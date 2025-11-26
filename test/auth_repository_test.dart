import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:movie_night_recommender/features/auth/data/repositories/auth_repository.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockGoogleSignIn extends Mock implements GoogleSignIn {}
class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}
class MockGoogleSignInAuthentication extends Mock implements GoogleSignInAuthentication {}
class MockUserCredential extends Mock implements UserCredential {}

class FakeOAuthCredential extends Fake implements OAuthCredential {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeOAuthCredential());
  });

  group('AuthRepository.signInWithGoogle', () {
    late MockFirebaseAuth mockFirebaseAuth;
    late MockGoogleSignIn mockGoogleSignIn;
    late AuthRepository authRepository;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      mockGoogleSignIn = MockGoogleSignIn();
      authRepository = AuthRepository(
        firebaseAuth: mockFirebaseAuth,
        googleSignIn: mockGoogleSignIn,
      );
    });

    test('returns UserCredential when sign-in succeeds', () async {
      final mockAccount = MockGoogleSignInAccount();
      final mockAuth = MockGoogleSignInAuthentication();
      final mockUserCredential = MockUserCredential();

      when(() => (mockGoogleSignIn as dynamic).signIn()).thenAnswer((_) async => mockAccount);
      when(() => (mockAccount as dynamic).authentication).thenReturn(mockAuth);
      when(() => (mockAuth as dynamic).idToken).thenReturn('test-id');
      when(() => (mockAuth as dynamic).accessToken).thenReturn('test-access');

      when(() => mockFirebaseAuth.signInWithCredential(any())).thenAnswer((_) async => mockUserCredential);

      final result = await authRepository.signInWithGoogle();

      expect(result, equals(mockUserCredential));
      verify(() => (mockGoogleSignIn as dynamic).signIn()).called(1);
      verify(() => mockFirebaseAuth.signInWithCredential(any())).called(1);
    });

    test('throws when user cancels sign-in', () async {
      when(() => (mockGoogleSignIn as dynamic).signIn()).thenAnswer((_) async => null);

      expect(() => authRepository.signInWithGoogle(), throwsA(isA<Exception>()));
      verify(() => (mockGoogleSignIn as dynamic).signIn()).called(1);
    });
  });
}
