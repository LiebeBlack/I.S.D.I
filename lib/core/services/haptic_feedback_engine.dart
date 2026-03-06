import 'package:flutter/services.dart';
import 'package:isla_digital/core/services/logging_service.dart';

/// Centralized engine for Contextual Haptic Feedback (Feature 24).
/// 
/// Provides unified methods to trigger device vibrations corresponding to
/// distinct user actions, enhancing the tactile experience, especially
/// for children needing multisensory reinforcement.
class HapticFeedbackEngine {
  HapticFeedbackEngine._();

  static final HapticFeedbackEngine instance = HapticFeedbackEngine._();
  bool _enabled = true;

  /// Toggles haptic feedback on or off globally.
  void setEnabled(bool isEnabled) {
    _enabled = isEnabled;
    LoggingService.i('HapticFeedbackEngine: enabled = $_enabled');
  }

  /// Triggered on successful actions (e.g., completing a puzzle).
  Future<void> success() async {
    if (!_enabled) return;
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.heavyImpact();
  }

  /// Triggered on errors or incorrect actions to provide negative reinforcement signaling.
  Future<void> error() async {
    if (!_enabled) return;
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 50));
    await HapticFeedback.heavyImpact();
  }

  /// Triggered on standard button taps and navigations.
  Future<void> selection() async {
    if (!_enabled) return;
    await HapticFeedback.selectionClick();
  }

  /// Triggered on soft interactions, like picking up a draggable item.
  Future<void> light() async {
    if (!_enabled) return;
    await HapticFeedback.lightImpact();
  }
}
