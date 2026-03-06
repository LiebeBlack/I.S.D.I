import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:freerasp/freerasp.dart';

import 'logging_service.dart';

/// Service responsible for proactive threat protection.
/// 
/// Utilizes Talsec FreeRASP to detect rooted/jailbroken devices, debuggers,
/// emulators, and app tampering attempts. Provides callbacks to gracefully
/// handle identified threats, ensuring an educational environment remains secure.
class SecurityService {
  SecurityService._();

  static Future<void> initialize() async {
    if (kIsWeb) return; // FreeRASP doesn't support Web

    // Talsec Configuration
    final config = TalsecConfig(
      androidConfig: AndroidConfig(
        packageName: 'com.liebeblack.isla_digital',
        signingCertHashes: ['YOUR_SHA256_CERTIFICATE_HASH_HERE'], // TODO: Replace in production
        supportedStores: ['com.sec.android.app.samsungapps'],
      ),
      iosConfig: IOSConfig(
        bundleIds: ['com.liebeblack.islaDigital'],
        teamId: 'YOUR_APPLE_TEAM_ID', // TODO: Replace in production
      ),
      watcherMail: 'security@isladigital.edu.ve',
      isProd: !kDebugMode,
    );

    // Callbacks for detected threats
    final callback = ThreatCallback(
      onAppIntegrity: () => _handleThreat('App Integrity compromised (Signature mismatch)'),
      onObfuscationIssues: () => _handleThreat('Obfuscation issues detected'),
      onDebug: () => _handleThreat('Active Debugger detected'),
      onDeviceBinding: () => _handleThreat('Device binding corrupted'),
      onDeviceID: () => _handleThreat('Device ID is suspicious'),
      onHooks: () => _handleThreat('Hooking framework detected (Frida/Xposed)'),
      onPrivilegedAccess: () => _handleThreat('Root / Jailbreak detected'),
      onSecureHardwareNotAvailable: () => _handleThreat('Secure Hardware not available'),
      onSimulator: () => _handleThreat('Emulator / Simulator detected'),
      onUnofficialStore: () => _handleThreat('Installed from untrusted source'),
    );

    try {
      // Attach threat listener and start RASP protection
      Talsec.instance.attachListener(callback);
      await Talsec.instance.start(config);
      LoggingService.i('SecurityService: FreeRASP initialized and monitoring threats.');
    } catch (e, stack) {
      LoggingService.e('SecurityService: Failed to initialize FreeRASP', e, stack);
    }
  }

  static void _handleThreat(String threatDesc) {
    LoggingService.e('🔥 SECURITY THREAT DETECTED: $threatDesc');
    
    // In production, you might want to force kill the app or clear the secure storage
    if (!kDebugMode) {
      // SecureStorageService.clearSession(); // Example proactive action
      SystemNavigator.pop(); // Gracefully exits the app
    }
  }
}
