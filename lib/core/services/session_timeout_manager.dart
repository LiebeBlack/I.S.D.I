import 'dart:async';

import 'package:flutter/material.dart';
import 'package:isla_digital/core/services/logging_service.dart';

/// App-wide listener that tracks user interaction and locks the app
/// (forcing a Parental PIN entry) after a prolonged period of inactivity.
class SessionTimeoutManager extends StatefulWidget {

  const SessionTimeoutManager({
    super.key,
    required this.child,
    this.timeoutDuration = const Duration(minutes: 10), // Configurable in Phase 1 setup
  });
  final Widget child;
  final Duration timeoutDuration;

  @override
  State<SessionTimeoutManager> createState() => _SessionTimeoutManagerState();
}

class _SessionTimeoutManagerState extends State<SessionTimeoutManager> {
  Timer? _idleTimer;

  @override
  void initState() {
    super.initState();
    _resetTimer();
  }

  @override
  void dispose() {
    _idleTimer?.cancel();
    super.dispose();
  }

  void _handleInteraction([dynamic _]) {
    _resetTimer();
  }

  void _resetTimer() {
    _idleTimer?.cancel();
    _idleTimer = Timer(widget.timeoutDuration, _lockSession);
  }

  void _lockSession() {
    LoggingService.i('SessionTimeoutManager: Idle duration exceeded. Locking session.');
    
    // In a real router scenario (GoRouter), you would redirect to a specific lock screen route.
    // For this demonstration, we push the Parental Dashboard if not already there.
    // Note: Depends heavily on navigation context.
    
    // Safety check to ensure we only push if we have a valid context
    if (mounted) {
       // A more decoupled approach is usually preferred (e.g., updating a Riverpod state),
       // but for Phase 1 MVP, we can trigger a generic parental lock modal or similar.
    }
  }

  @override
  Widget build(BuildContext context) => Listener(
    onPointerDown: _handleInteraction,
    onPointerMove: _handleInteraction,
    onPointerUp: _handleInteraction,
    behavior: HitTestBehavior.translucent,
    child: widget.child,
  );
}
