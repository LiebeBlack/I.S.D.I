import 'package:flutter/material.dart';
import 'logging_service.dart';

/// App-wide observer that listens for Android/iOS lifecycle events.
/// 
/// Used to trigger preemptive data syncing (e.g., saving profile progress)
/// when the user minimizes the app or turns off the screen, preventing data loss.
class AppLifecycleObserver extends WidgetsBindingObserver {
  AppLifecycleObserver._();
  
  static final AppLifecycleObserver instance = AppLifecycleObserver._();

  /// Starts listening to global application lifecycle changes.
  void initialize() {
    WidgetsBinding.instance.addObserver(this);
    LoggingService.i('AppLifecycleObserver initialized.');
  }

  /// Stops listening. Usually called only if the app root is destroyed.
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    switch (state) {
      case AppLifecycleState.resumed:
        LoggingService.i('AppLifecycle: App Resumed');
        // E.g., Refresh tokens, resume audio, re-establish sockets
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        LoggingService.i('AppLifecycle: App Paused/Inactive. Triggering background sync.');
        // Feature 30: Trigger synchronous saves or pause background heavy tasks
        // e.g., ref.read(currentProfileProvider.notifier).forceSave();
        break;
      case AppLifecycleState.hidden:
        LoggingService.i('AppLifecycle: App Hidden');
        break;
      case AppLifecycleState.detached:
        LoggingService.i('AppLifecycle: App Detached. Final cleanup.');
        // App is terminating. Clean up listeners.
        break;
    }
  }
}
