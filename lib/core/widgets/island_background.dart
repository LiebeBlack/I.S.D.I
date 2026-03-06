import 'package:flutter_animate/flutter_animate.dart';
import 'package:isla_digital/core/core.dart';

/// Fondo temático de la Isla de Margarita
/// Usa un balance entre una imagen real y capas vectoriales dinámicas.
class IslandBackground extends StatelessWidget {
  const IslandBackground({
    super.key,
    this.child,
    this.showDecorations = true,
  });

  final Widget? child;
  final bool showDecorations;

  @override
  Widget build(BuildContext context) => Scaffold(
      body: Stack(
        children: [
          // 1. Imagen de Fondo (La base del atardecer/día)
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgrounds/bg_beach_tropical_day.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // 2. Capa de Gradiente (Suaviza la imagen para mejorar legibilidad)
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.1),
                    IslaColors.oceanBlue.withValues(alpha: 0.2),
                  ],
                ),
              ),
            ),
          ),

          if (showDecorations) ...[
            // 3. El Sol (con un ligero pulso)
            Positioned(
              top: -40,
              right: -40,
              child: RepaintBoundary(
                child: _buildSun()
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .scale(
                        begin: const Offset(1, 1),
                        end: const Offset(1.1, 1.1),
                        duration: 4.seconds),
              ),
            ),

            // 4. Las Olas (en la parte inferior)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: RepaintBoundary(child: _buildWaves()),
            ),

            // 5. Palmera (decorativa)
            Positioned(
              bottom: 30,
              left: 10,
              child: _buildPalmTree().animate().slideX(begin: -0.5, end: 0),
            ),
          ],

          // 6. Contenido Principal
          if (child != null) Positioned.fill(child: child!),
        ],
      ),
    );

  Widget _buildSun() => Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            IslaColors.sunflower.withValues(alpha: 0.8),
            IslaColors.sunflower.withValues(alpha: 0.3),
            Colors.transparent,
          ],
        ),
      ),
    );

  Widget _buildWaves() => SizedBox(
      height: 120,
      child: CustomPaint(
        size: Size.infinite,
        painter: WavesPainter(),
      ),
    );

  Widget _buildPalmTree() => Icon(
      Icons.park_rounded, // Usamos la versión rounded para estética infantil
      size: 100,
      color: IslaColors.jungleGreen.withValues(alpha: 0.4),
    );
}

/// Pintor de Olas Dinámicas
class WavesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.7);

    // Dibujamos una curva suave tipo seno para las olas
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.5,
        size.width * 0.5, size.height * 0.7);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.9, size.width, size.height * 0.7);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
