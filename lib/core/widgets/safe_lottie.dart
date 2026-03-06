import 'package:isla_digital/core/core.dart';
import 'package:lottie/lottie.dart';

/// Un widget de animación Lottie que maneja fallos de carga
/// transformándolos en un ícono con efecto de "respiración".
class SafeLottie extends StatelessWidget {
  const SafeLottie({
    super.key,
    required this.path,
    this.backupIcon = Icons.extension_rounded,
    this.size = 150,
    this.repeat = true,
    this.fit = BoxFit.contain,
  });

  final String path;
  final IconData backupIcon;
  final double size;
  final bool repeat;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    // Feature 9 & 11: Asset Preloading & RepaintBoundary Optimization
    // Check if the asset was pre-warmed in the isolate cache
    final preloadedComposition = AssetPreloaderService.getParsedLottie(path);

    Widget lottieWidget;
    if (preloadedComposition != null) {
      // Pre-parsed — use Lottie.asset which will hit the LRU cache
      lottieWidget = Lottie.asset(
        path,
        fit: fit,
        repeat: repeat,
        frameRate: FrameRate.composition,
        errorBuilder: (context, error, stackTrace) {
          LoggingService.w('SafeLottie: Error rendering preloaded $path', error, stackTrace);
          return AssetPlaceholderFallback(
            width: size,
            height: size,
            placeholderType: _inferPlaceholderType(path),
          );
        },
      );
    } else {
      // Fallback to standard asset loading (main thread parse)
      lottieWidget = Lottie.asset(
        path,
        fit: fit,
        repeat: repeat,
        frameRate: FrameRate.composition,
        errorBuilder: (context, error, stackTrace) {
          LoggingService.w('SafeLottie: Failed to load Lottie asset $path', error, stackTrace);
          return AssetPlaceholderFallback(
            width: size,
            height: size,
            placeholderType: _inferPlaceholderType(path),
          );
        },
      );
    }

    // Wrap heavily animating widgets in a RepaintBoundary to avoid repainting
    // the entire screen structure on every frame tick of the animation.
    return RepaintBoundary(
      child: SizedBox(
        width: size,
        height: size,
        child: lottieWidget,
      ),
    );
  }

  PlaceholderType _inferPlaceholderType(String path) {
    if (path.contains('/characters/')) return PlaceholderType.character;
    if (path.contains('/success/')) return PlaceholderType.ui;
    if (path.contains('/backgrounds/')) return PlaceholderType.background;
    return PlaceholderType.icon;
  }
}


