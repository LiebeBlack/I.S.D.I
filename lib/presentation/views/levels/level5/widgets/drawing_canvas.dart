import 'package:flutter/material.dart';
import 'package:isla_digital/core/theme/app_theme.dart';

class DrawingCanvas extends StatefulWidget {
  final VoidCallback onProgress;
  const DrawingCanvas({super.key, required this.onProgress});

  @override
  State<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  List<Offset?> points = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: IslaColors.sunsetPink.withValues(alpha: 0.3), width: 4),
      ),
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            RenderBox renderBox = context.findRenderObject() as RenderBox;
            points.add(renderBox.globalToLocal(details.globalPosition));
          });
          if (points.length % 50 == 0) widget.onProgress();
        },
        onPanEnd: (details) => points.add(null),
        child: CustomPaint(
          painter: CanvasPainter(points: points),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class CanvasPainter extends CustomPainter {
  final List<Offset?> points;
  CanvasPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = IslaColors.sunsetPink
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 8.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}