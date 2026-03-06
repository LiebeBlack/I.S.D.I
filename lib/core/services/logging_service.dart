import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// A centralized, structured logging service that abstracts away the underlying logger implementation.
/// 
/// It routes logs to the console (via `logger`) during development and forwards
/// warning/error level logs to Crashlytics and Sentry in production environments.
class LoggingService {

  /// Default constructor preventing instantiation.
  LoggingService._();
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  /// Logs a debug message. Usually only visible in development environments.
  /// Use this for fine-grained execution flow tracing.
  static void d(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Logs an informational message.
  /// Use this for important lifecycle events (e.g., "User logged in", "Asset loaded").
  static void i(String message) {
    _logger.i(message);
    if (!kDebugMode) {
      FirebaseCrashlytics.instance.log('INFO: $message');
    }
  }

  /// Logs a warning. Indicates something unexpected happened, but the app can recover.
  /// Forwards to Crashlytics as a non-fatal error in production.
  static void w(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
    if (!kDebugMode) {
      FirebaseCrashlytics.instance.recordError(error ?? message, stackTrace, reason: 'WARNING: $message');
    }
  }

  /// Logs a critical error. Use this when the app encounters a breaking condition.
  /// Automatically forwards the error and stack trace to Sentry and Firebase Crashlytics.
  static Future<void> e(String message, [dynamic error, StackTrace? stackTrace]) async {
    _logger.e(message, error: error, stackTrace: stackTrace);
    
    // Always report severe errors to telemetry services if not running locally
    if (!kDebugMode) {
      await FirebaseCrashlytics.instance.recordError(error ?? message, stackTrace, reason: 'ERROR: $message', fatal: true);
      await Sentry.captureException(error ?? message, stackTrace: stackTrace);
    }
  }
}
