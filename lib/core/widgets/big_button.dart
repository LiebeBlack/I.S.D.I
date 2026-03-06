import 'package:isla_digital/core/core.dart';

class BigButton extends StatefulWidget {
  const BigButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
    this.width,
    this.height = 70.0,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;
  final double? width;
  final double height;

  @override
  State<BigButton> createState() => _BigButtonState();
}

class _BigButtonState extends State<BigButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final double shadowHeight = _isPressed ? 2 : 6;
    final double topPadding = _isPressed ? 4 : 0;

    // Create a darker shade using HSL for more vibrant depth
    final hsl = HSLColor.fromColor(widget.color);
    final darkColor =
        hsl.withLightness((hsl.lightness - 0.2).clamp(0.0, 1.0)).toColor();

    return Semantics(
      button: true,
      enabled: true,
      label: widget.label,
      hint: 'Botón de acción principal',
      child: GestureDetector(
        onTapDown: (_) {
          HapticFeedbackEngine.instance.light();
          setState(() => _isPressed = true);
        },
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onPressed();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          margin: EdgeInsets.only(top: topPadding, bottom: 6 - shadowHeight),
          width: widget.width ?? double.infinity,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: darkColor,
                offset: Offset(0, shadowHeight),
              ),
            ],
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: [
                  widget.color,
                  Color.lerp(widget.color, darkColor, 0.3)!,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icon, size: 28, color: Colors.white),
                const SizedBox(width: 12),
                Text(
                  widget.label.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CircleActionButton extends StatelessWidget {
  const CircleActionButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onPressed,
    this.label,
    this.size = 60,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final String? label;
  final double size;

  @override
  Widget build(BuildContext context) {
    final hsl = HSLColor.fromColor(color);
    final darkColor =
        hsl.withLightness((hsl.lightness - 0.15).clamp(0.0, 1.0)).toColor();

    return Semantics(
      button: true,
      enabled: true,
      label: label ?? 'Botón circular de acción',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              HapticFeedbackEngine.instance.selection();
              onPressed();
            },
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [color, darkColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: darkColor.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
                border: Border.all(color: Colors.white, width: 2.5),
              ),
              child: Icon(icon, size: size * 0.45, color: Colors.white),
            ),
          ),
          if (label != null) ...[
            const SizedBox(height: 8),
            Text(
              label!,
              style: const TextStyle(
                color: IslaColors.oceanDark,
                fontWeight: FontWeight.w900,
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class AnimatedIconButton extends StatefulWidget {
  const AnimatedIconButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onPressed,
    this.size = 56,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final double size;

  @override
  State<AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<AnimatedIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    enabled: true,
    hint: 'Botón de ícono animado',
    child: GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        HapticFeedbackEngine.instance.selection();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Icon(widget.icon, size: widget.size * 0.5, color: Colors.white),
        ),
      ),
    ),
  );
}
