import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'logging_service.dart';

/// Service responsible for secure, encrypted on-device storage.
///
/// Wraps `flutter_secure_storage` to provide a robust API for handling sensitive data
/// like parental PINs, session tokens, and feature flags. Includes fallback mechanisms.
class SecureStorageService {

  SecureStorageService._();
  static const FlutterSecureStorage _vault = FlutterSecureStorage(
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  /// Key definitions to prevent typos
  static const String _parentalPinKey = 'isla_parental_pin_v2';
  static const String _sessionTokenKey = 'isla_session_token'; // Singleton enforcement

  // ===========================================================================
  // PARENTAL PIN MANAGEMENT
  // ===========================================================================

  /// Securely stores the parental dashboard PIN.
  static Future<bool> saveParentalPin(String pin) async {
    try {
      if (pin.length < 4 || !RegExp(r'^\d+$').hasMatch(pin)) {
        throw ArgumentError('PIN must be at least 4 digits');
      }
      await _vault.write(key: _parentalPinKey, value: pin);
      LoggingService.i('SecureStorage: Parental PIN updated securely.');
      return true;
    } catch (e, stack) {
      LoggingService.e('SecureStorage: Failed to save PIN', e, stack);
      return false;
    }
  }

  /// Verifies if the provided PIN matches the securely stored PIN.
  static Future<bool> verifyParentalPin(String inputPin) async {
    try {
      final storedPin = await _vault.read(key: _parentalPinKey);
      
      // If no PIN exists, we assume fallback/default behavior (e.g., '1234')
      if (storedPin == null) {
        LoggingService.w('SecureStorage: Verifying against non-existent PIN.');
        return inputPin == '1234'; 
      }
      
      return storedPin == inputPin;
    } catch (e, stack) {
      LoggingService.e('SecureStorage: PIN verification failed', e, stack);
      return false; // Fail secure
    }
  }

  /// Checks if a custom parental PIN has been configured in the secure vault.
  static Future<bool> hasCustomPin() async {
    try {
      final pin = await _vault.read(key: _parentalPinKey);
      return pin != null;
    } catch (e) {
      return false;
    }
  }

  // ===========================================================================
  // SESSION / TOKEN MANAGEMENT
  // ===========================================================================

  /// Securely stores the active session token.
  static Future<void> saveSessionToken(String token) async {
    try {
      await _vault.write(key: _sessionTokenKey, value: token);
    } catch (e, stack) {
      LoggingService.e('SecureStorage: Failed to save session token', e, stack);
    }
  }

  /// Clears all heavily sensitive data from the vault (e.g., on manual logout).
  static Future<void> clearSession() async {
    try {
      await _vault.delete(key: _sessionTokenKey);
      LoggingService.i('SecureStorage: Session cleared.');
    } catch (e, stack) {
      LoggingService.e('SecureStorage: Failed to clear session', e, stack);
    }
  }
}
