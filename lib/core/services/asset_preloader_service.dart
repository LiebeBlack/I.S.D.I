import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'logging_service.dart';

/// Service dedicated to pre-warming and decoding heavy assets off the main UI thread.
/// 
/// Lottie animations and large SVGs can cause the UI to stutter (jank) during
/// initial load on media-to-low end Android devices. This service uses `compute`
/// (Dart Isolates) to pre-parse JSON strings into memory during the splash screen.
class AssetPreloaderService {
  AssetPreloaderService._();

  // In-memory cache for parsed Lottie compositions
  static final Map<String, Map<String, dynamic>> _lottieCache = {};

  /// Heavy lifting function intended to run in an Isolate.
  /// Parses standard JSON strings into Dart Maps.
  static Map<String, dynamic> _parseJsonSync(String jsonString) => jsonDecode(jsonString) as Map<String, dynamic>;

  /// Preloads and parses a Lottie JSON file using a background Isolate.
  static Future<void> preloadLottie(String assetPath) async {
    if (_lottieCache.containsKey(assetPath)) return;

    try {
      // 1. Read file from disk/bundle (Runs on main thread, but fast for strings)
      final jsonString = await rootBundle.loadString(assetPath);
      
      // 2. Parse JSON string to Map (Runs on Background Isolate)
      // This is the heavy operation that causes UI jank if done on the main thread.
      final parsedJson = await compute(_parseJsonSync, jsonString);
      
      // 3. Store in memory cache
      _lottieCache[assetPath] = parsedJson;
      LoggingService.d('AssetPreloader: Successfully preloaded $assetPath');
    } catch (e, stack) {
      LoggingService.e('AssetPreloader: Failed to preload $assetPath', e, stack);
    }
  }

  /// Initiates the preloading sequence for critical application assets.
  /// Call this during app bootstrap (e.g., inside runZonedGuarded).
  static Future<void> preWarmCriticalAssets() async {
    final sw = Stopwatch()..start();
    
    // List of critical animations that MUST be smooth on first render
    final criticalLotties = [
      'assets/animations/ui/shield.json',
      'assets/animations/ui/welcome_island.json',
      'assets/animations/ui/wave_loading.json',
      'assets/animations/ui/welcome_sun.json',
      'assets/animations/ui/power.json',
      'assets/animations/ui/swipe_up.json',
    ];

    try {
      // Use Future.wait to parallelize the Isolate spawning process
      await Future.wait(criticalLotties.map(preloadLottie));
      LoggingService.i('AssetPreloader: Critical pre-warming completed in ${sw.elapsedMilliseconds}ms');
    } catch (e) {
      LoggingService.w('AssetPreloader: Some assets failed to pre-warm.');
    } finally {
      sw.stop();
    }
  }

  /// Retrieves a pre-parsed Lottie JSON from memory if available.
  static Map<String, dynamic>? getParsedLottie(String assetPath) => _lottieCache[assetPath];
}
