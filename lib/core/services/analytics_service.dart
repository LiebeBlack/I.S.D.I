import 'package:flutter/foundation.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

import 'logging_service.dart';

/// Aggregates and dispatches telemetry and analytics events across configured platforms.
///
/// This service acts as an abstraction layer over Firebase Analytics and Mixpanel,
/// allowing for uniform event tracking, user property management, and screen views logging.
class AnalyticsService {

  AnalyticsService._();
  static Mixpanel? _mixpanel; // Prevent instantiation

  /// Initializes all underlying analytics engines. Must be called during app bootstrap.
  static Future<void> initialize() async {
    try {
      // Initialize Mixpanel (Replace with actual Token in production via .env)
      _mixpanel = await Mixpanel.init(
        'MOCK_MIXPANEL_TOKEN_12345', // TODO: Move to Environment Config (Feature 21)
        trackAutomaticEvents: true,
      );
      
      LoggingService.i('AnalyticsService Initialized Successfully');
    } catch (e, stack) {
      LoggingService.e('Failed to initialize AnalyticsService', e, stack);
    }
  }

  /// Tracks a custom event across all configured analytics platforms.
  /// 
  /// [eventName] The name of the event (e.g., 'level_completed').
  /// [properties] Optional map of key-value pairs enriching the event data.
  static Future<void> trackEvent(String eventName, {Map<String, dynamic>? properties}) async {
    if (kDebugMode) {
      LoggingService.d('Analytics Event: $eventName', properties);
      return; // Do not pollute production metrics with debug sessions
    }

    try {
      // Dispatch to Mixpanel
      _mixpanel?.track(eventName, properties: properties);
    } catch (e, stack) {
      LoggingService.w('Failed to track event $eventName', e, stack);
    }
  }

  /// Associates the current session with a specific user ID.
  static Future<void> identifyUser(String userId) async {
    if (kDebugMode) return;
    
    _mixpanel?.identify(userId);
  }
}
