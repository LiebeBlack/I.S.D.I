import 'package:isla_digital/core/core.dart';

class DrawingCanvas extends StatefulWidget {
  const DrawingCanvas({super.key, required this.onProgress});
  final VoidCallback onProgress;

  @override
  State<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  List<Offset?> points = [];

  @override
  Widget build(BuildContext context) => Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: IslaColors.sunsetPink.withValues(alpha: 0.3), width: 4),
      ),
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            final RenderBox renderBox =
                context.findRenderObject()! as RenderBox;
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

class CanvasPainter extends CustomPainter {
  CanvasPainter({required this.points});
  final List<Offset?> points;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = IslaColors.sunsetPink
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;

    final path = Path();
    bool isNewPath = true;

    for (int i = 0; i < points.length; i++) {
      final point = points[i];
      if (point == null) {
        isNewPath = true;
      } else {
        if (isNewPath) {
          path.moveTo(point.dx, point.dy);
          isNewPath = false;
        } else {
          // Optimized continuous drawing
          path.lineTo(point.dx, point.dy);
        }
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
