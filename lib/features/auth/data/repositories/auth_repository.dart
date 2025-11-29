import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  Stream<User?> get user => _firebaseAuth.authStateChanges();
  User? get currentUser => _firebaseAuth.currentUser;

  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<UserCredential> logIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> logOut() async {
    try {
      await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }


  //   Future<UserCredential> signInWithGoogle() async {
  //     try {
  //       // Use dynamic calls to be resilient across google_sign_in versions
  //       final dynamic googleUser = await (_googleSignIn as dynamic).signIn();
  //       // final dynamic googleUser = await _googleSignIn.signIn();

  //       if (googleUser == null) {
  //         throw Exception('Google sign-in aborted by user');
  //       }

  //       // The `authentication` value shape differs between versions; access dynamically
  //       final dynamic googleAuth = await googleUser.authentication;
  //       final String? idToken = googleAuth?.idToken as String?;
  //       final String? accessToken = googleAuth?.accessToken as String?;

  //       final AuthCredential credential = GoogleAuthProvider.credential(
  //         idToken: idToken,
  //         accessToken: accessToken,
  //       );

  //       return await _firebaseAuth.signInWithCredential(credential);
  //     } catch (e) {
  //       throw Exception(e.toString());
  //     }
  //   }

  Future<UserCredential> signInWithGoogle() async {
    try {
      // Initialize GoogleSignIn with serverClientId (required for Android)
      // This is the Web OAuth 2.0 client ID from your google-services.json
      await GoogleSignIn.instance.initialize(
        serverClientId: '786692485904-k3a1o1cl2833nse057ush4b4godaqbu3.apps.googleusercontent.com',
      );

      // Trigger the authentication flow
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance.authenticate();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      return await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
