import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:isla_digital/core/core.dart';

/// Unobtrusive overlay that warns the user when the device loses internet connection.
/// 
/// Designed specifically for environments with intermittent connectivity (e.g., Venezuela).
/// It listens to `connectivity_plus` streams and displays an animated banner.
class NetworkConnectivityOverlay extends StatefulWidget {

  const NetworkConnectivityOverlay({super.key, required this.child});
  final Widget child;

  @override
  State<NetworkConnectivityOverlay> createState() => _NetworkConnectivityOverlayState();
}

class _NetworkConnectivityOverlayState extends State<NetworkConnectivityOverlay> {
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    _checkInitialConnectivity();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _checkInitialConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    setState(() {
      _isOffline = result.contains(ConnectivityResult.none);
    });
    if (_isOffline) {
      LoggingService.w('Network: Device went offline.');
    } else {
      LoggingService.i('Network: Connection restored.');
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
      children: [
        widget.child,
        if (_isOffline)
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: IslaColors.coralReef.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.wifi_off_rounded, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Estás navegando sin conexión. Algunas funciones pueden estar limitadas.',
                        style: DynamicThemingEngine.labelStyle.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .animate()
            .slideY(begin: -2, end: 0, duration: 400.ms, curve: Curves.easeOutBack)
            .fadeIn(),
          ),
      ],
    );
}
