import 'package:flutter/material.dart';
import 'package:isla_digital/core/theme/app_theme.dart';
import 'package:lottie/lottie.dart';

/// A Lottie animation widget that safely handles missing assets
/// with a playful bounce fallback icon.
class SafeLottie extends StatelessWidget {
  const SafeLottie({
    super.key,
    required this.path,
    required this.backupIcon,
    this.size = 150,
    this.repeat = true,
  });

  final String path;
  final IconData backupIcon;
  final double size;
  final bool repeat;

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      path,
      width: size,
      height: size,
      fit: BoxFit.contain,
      repeat: repeat,
      errorBuilder: (context, error, stackTrace) {
        return TweenAnimationBuilder(
          tween: Tween<double>(begin: 0.9, end: 1.1),
          duration: const Duration(milliseconds: 1500),
          curve: Curves.easeInOutSine,
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: Icon(
                backupIcon,
                size: size * 0.7,
                color: IslaColors.oceanBlue.withValues(alpha: 0.8),
              ),
            );
          },
        );
      },
    );
  }
}
