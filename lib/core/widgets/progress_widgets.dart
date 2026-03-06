import 'package:flutter_animate/flutter_animate.dart';
import 'package:isla_digital/core/core.dart';
import 'package:isla_digital/core/utils/color_utils.dart';

/// Barra de progreso estilo "Isla" con gradientes y reflejos
class IslandProgressBar extends StatelessWidget {
  const IslandProgressBar({
    super.key,
    required this.progress,
    this.maxProgress = 100,
    this.fillColor,
    this.height = 20,
    this.showPercentage = true,
    this.label,
  })  : assert(maxProgress > 0, 'maxProgress must be strictly positive'),
        assert(height > 0, 'height must be strictly positive'),
        assert(progress >= 0, 'progress cannot be negative');

  final int progress;
  final int maxProgress;
  final Color? fillColor;
  final double height;
  final bool showPercentage;
  final String? label;

  @override
  Widget build(BuildContext context) {
    // Zero-error: Fallback safely if assertions are disabled in prod
    final safeMax = maxProgress > 0 ? maxProgress : 1; 
    final clampedProgress = progress.clamp(0, safeMax);
    final percentage = clampedProgress / safeMax;
    final baseColor = fillColor ?? IslaColors.oceanBlue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 6),
            child: Text(
              label!.toUpperCase(),
              style: const TextStyle(
                color: IslaColors.oceanDark,
                fontWeight: FontWeight.w900,
                fontSize: 12,
                letterSpacing: 1.2,
              ),
            ),
          ),
        LayoutBuilder(
          builder: (context, constraints) => Container(
              height: height,
              width: double.infinity,
              decoration: BoxDecoration(
                color: IslaColors.mist,
                borderRadius: BorderRadius.circular(height / 2),
                // FIX: Eliminado 'inset: true' para usar sombras estándar y evitar error
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Capa de Progreso Animada
                  AnimatedContainer(
                    duration: 600.ms,
                    curve: Curves.elasticOut,
                    width: (percentage * constraints.maxWidth)
                        .clamp(0, constraints.maxWidth),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(height / 2),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          baseColor,
                          ColorUtils.lighten(baseColor, 0.15),
                        ],
                      ),
                    ),
                  ).animate(target: percentage).shimmer(
                        duration: 2.seconds,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),

                  // Texto de porcentaje
                  if (showPercentage)
                    Align(
                      child: Text(
                        '${(percentage * 100).toInt()}%',
                        style: TextStyle(
                          color: percentage > 0.5
                              ? Colors.white
                              : IslaColors.oceanDark,
                          fontWeight: FontWeight
                              .w900, // FIX: Cambiado de .black a .w900
                          fontSize: height * 0.55,
                          shadows: percentage > 0.5
                              ? [
                                  const Shadow(
                                      blurRadius: 2, color: Colors.black26)
                                ]
                              : null,
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ),
      ],
    );
  }
}

/// Indicador de pasos con iconos de éxito
class StepIndicator extends StatelessWidget {
  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.activeColor,
  });

  final int currentStep;
  final int totalSteps;
  final Color? activeColor;

  @override
  Widget build(BuildContext context) => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final isCompleted = index < currentStep;
        final isCurrent = index == currentStep;
        final color = activeColor ?? IslaColors.jungleGreen;

        return AnimatedContainer(
          duration: 300.ms,
          width: isCurrent ? 32 : 24,
          height: 24,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isCompleted
                ? color
                : (isCurrent ? color.withValues(alpha: 0.2) : IslaColors.mist),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isCurrent || isCompleted ? color : IslaColors.grey,
              width: 2,
            ),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                : Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isCurrent
                          ? color
                          : (isCompleted ? Colors.white : IslaColors.grey),
                    ),
                  ),
          ),
        )
            .animate(target: isCurrent ? 1 : 0)
            .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1));
      }),
    );
}
