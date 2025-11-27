import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class LocalAuthService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> isDeviceSupported() async {
    try {
      return await _auth.isDeviceSupported();
    } catch (e) {
      return false;
    }
  }

  Future<bool> authenticate() async {
    try {
      final isSupported = await isDeviceSupported();
      if (!isSupported) return true; // Allow access if not supported (or handle differently based on requirements)

      final canCheckBiometrics = await _auth.canCheckBiometrics;
      if (!canCheckBiometrics) return true; // Allow access if no biometrics enrolled
      // Try to authenticate. Some Android embedder configurations
      // (e.g. when the activity is not a FragmentActivity) will throw a
      // LocalAuthException with a UI-unavailable error. Catch that and
      // fall back gracefully instead of crashing the app.
      try {
        return await _auth.authenticate(
          localizedReason: 'Please authenticate to access the app',
          biometricOnly: false,
        );
      } on LocalAuthException catch (e) {
        // Known runtime issue on some Android hosts: UI not available.
        // Treat this as a graceful fallback rather than a hard failure.
        final code = e.code.toString().toLowerCase();
        if (code.contains('ui') || code.contains('unavailable')) {
          return true;
        }
        return false;
      }
    } on PlatformException catch (e) {
      // Handle specific error codes if needed
      if (e.code == 'NotAvailable' || e.code == 'NotEnrolled') {
        return true; // Allow access if auth is not available/enrolled
      }
      return false;
    }
  }
}
