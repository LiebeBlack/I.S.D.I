import 'dart:math' as math;
import 'package:isla_digital/core/core.dart';

/// A robust CustomPainter fallback that draws generic SVG-like shapes procedurally.
/// Used universally when an asset is missing to prevent layout breaks and maintain visual quality.
class AssetPlaceholderFallback extends StatelessWidget {
  const AssetPlaceholderFallback({
    super.key,
    this.width = 100,
    this.height = 100,
    this.placeholderType = PlaceholderType.character,
  });

  final double width;
  final double height;
  final PlaceholderType placeholderType;

  @override
  Widget build(BuildContext context) => SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _FallbackPainter(type: placeholderType),
      ),
    );
}

enum PlaceholderType { character, icon, background, ui }

class _FallbackPainter extends CustomPainter {
  _FallbackPainter({required this.type});
  final PlaceholderType type;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..style = PaintingStyle.fill;

    switch (type) {
      case PlaceholderType.character:
        _drawCharacter(canvas, size, center, paint);
        break;
      case PlaceholderType.icon:
        _drawIcon(canvas, size, center, paint);
        break;
      case PlaceholderType.background:
        _drawBackground(canvas, size, paint);
        break;
      case PlaceholderType.ui:
        _drawUI(canvas, size, center, paint);
        break;
    }
  }

  void _drawCharacter(Canvas canvas, Size size, Offset center, Paint paint) {
    // Body
    paint.color = IslaColors.sunflower;
    canvas.drawCircle(center, size.width * 0.4, paint);

    // Eyes
    paint.color = IslaColors.charcoal;
    final eyeOffset = size.width * 0.15;
    canvas.drawCircle(Offset(center.dx - eyeOffset, center.dy - eyeOffset),
        size.width * 0.05, paint);
    canvas.drawCircle(Offset(center.dx + eyeOffset, center.dy - eyeOffset),
        size.width * 0.05, paint);

    // Smile
    paint.color = IslaColors.sunsetPink;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = size.width * 0.05;
    paint.strokeCap = StrokeCap.round;
    final rect = Rect.fromCircle(center: center, radius: size.width * 0.2);
    canvas.drawArc(rect, 0, math.pi, false, paint);
  }

  void _drawIcon(Canvas canvas, Size size, Offset center, Paint paint) {
    paint.color = IslaColors.oceanLight;
    final path = Path()
      ..moveTo(center.dx, center.dy - size.height * 0.3)
      ..lineTo(center.dx + size.width * 0.3, center.dy + size.height * 0.3)
      ..lineTo(center.dx - size.width * 0.3, center.dy + size.height * 0.3)
      ..close();
    canvas.drawPath(path, paint);

    paint.color = IslaColors.oceanDark;
    canvas.drawCircle(center, size.width * 0.1, paint);
  }

  void _drawBackground(Canvas canvas, Size size, Paint paint) {
    paint.color = IslaColors.mist;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    paint.color = IslaColors.white.withValues(alpha: 0.4); // approx 100/255
    for (int i = 0; i < 5; i++) {
      canvas.drawCircle(
          Offset(size.width * (0.2 * i), size.height * (i.isEven ? 0.3 : 0.7)),
          size.width * 0.3,
          paint);
    }
  }

  void _drawUI(Canvas canvas, Size size, Offset center, Paint paint) {
    paint.color = IslaColors.slate.withValues(alpha: 0.2); // approx 50/255
    final RRect rrect = RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: center, width: size.width * 0.8, height: size.height * 0.8),
        const Radius.circular(16));
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
