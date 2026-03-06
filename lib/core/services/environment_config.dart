import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'logging_service.dart';

/// Provides type-safe access to environment variables.
///
/// Ensures environment configurations (dev, staging, prod) are securely 
/// and correctly loaded before application startup using `flutter_dotenv`.
class EnvironmentConfig {
  EnvironmentConfig._();

  /// Loads the appropriate .env file based on the runtime environment.
  static Future<void> initialize() async {
    try {
      // Logic for flavor detection (simplified for this context)
      // In a real pipeline, you'd use flutter run --dart-define=FLAVOR=prod
      const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
      
      await dotenv.load(fileName: '.env.$flavor');
      LoggingService.i('EnvironmentConfig: Loaded flavor -> $flavor');
    } catch (e, stack) {
      LoggingService.e('EnvironmentConfig: Failed to load .env file', e, stack);
      // Fallback to safe defaults if missing to prevent catastrophic boot failures
    }
  }

  // ===========================================================================
  // CONFIGURATION GETTERS (Type-Safe)
  // ===========================================================================

  static String get flavor => dotenv.env['FLAVOR'] ?? 'dev';
  static bool get isProduction => flavor == 'prod';

  static String get apiBaseUrl {
    final url = dotenv.env['API_BASE_URL'];
    if (url == null || url.isEmpty) {
      throw const FormatException('API_BASE_URL is not defined in the environment.');
    }
    return url;
  }

  static String get mixpanelToken => dotenv.env['MIXPANEL_TOKEN'] ?? '';
  static String get sentryDsn => dotenv.env['SENTRY_DSN'] ?? '';

  static bool get enableAnalytics =>
      (dotenv.env['ENABLE_ANALYTICS'] ?? 'false').toLowerCase() == 'true';

  static bool get enableCrashReporting =>
      (dotenv.env['ENABLE_CRASH_REPORTING'] ?? 'false').toLowerCase() == 'true';
}
