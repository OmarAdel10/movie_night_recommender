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

      // Call authenticate with a minimal set of named parameters.
      // Parameter names differ across `local_auth` versions; `biometricOnly`
      // is supported in older/newer variants, so use it here to prefer
      // biometric auth while allowing device credentials when false.
      return await _auth.authenticate(
        localizedReason: 'Please authenticate to access the app',
        biometricOnly: false,
      );
    } on PlatformException catch (e) {
      // Handle specific error codes if needed
      if (e.code == 'NotAvailable' || e.code == 'NotEnrolled') {
        return true; // Allow access if auth is not available/enrolled
      }
      return false;
    }
  }
}
