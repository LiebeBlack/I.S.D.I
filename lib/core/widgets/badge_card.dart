import 'package:isla_digital/core/core.dart' hide Badge;
import 'package:isla_digital/features/learning_cpa/domain/entities/badge.dart';

class BadgeCard extends StatefulWidget {
  const BadgeCard({
    super.key,
    required this.badge,
    this.isEarned = false,
    this.size = 80,
  }) : assert(size > 0, 'size must be strictly positive');

  final Badge badge;
  final bool isEarned;
  final double size;

  @override
  State<BadgeCard> createState() => _BadgeCardState();
}

class _BadgeCardState extends State<BadgeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Si ya la ganó, hacemos que la insignia tenga un pequeño "latido" constante
    if (widget.isEarned) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScaleTransition(
      scale: widget.isEarned
          ? Tween<double>(begin: 1, end: 1.05).animate(
              CurvedAnimation(parent: _controller, curve: Curves.easeInOut))
          : const AlwaysStoppedAnimation(1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Círculo de brillo exterior (solo si es ganada)
              if (widget.isEarned)
                Container(
                  width: widget.size + 10,
                  height: widget.size + 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.badge.color.withValues(alpha: 0.2),
                  ),
                ),

              // Cuerpo de la Insignia
              ColorFiltered(
                colorFilter: widget.isEarned
                    ? const ColorFilter.mode(
                        Colors.transparent, BlendMode.multiply)
                    : const ColorFilter.matrix(<double>[
                        0.2126,
                        0.7152,
                        0.0722,
                        0,
                        0,
                        0.2126,
                        0.7152,
                        0.0722,
                        0,
                        0,
                        0.2126,
                        0.7152,
                        0.0722,
                        0,
                        0,
                        0,
                        0,
                        0,
                        1,
                        0,
                      ]),
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        widget.badge.color,
                        widget.badge.color.withValues(alpha: 0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: widget.isEarned
                        ? [
                            BoxShadow(
                              color: widget.badge.color.withValues(alpha: 0.4),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                    border: Border.all(
                      color: widget.isEarned
                          ? IslaColors.sunflower
                          : Colors.grey.shade400,
                      width: widget.isEarned ? 4 : 2,
                    ),
                  ),
                  child: Icon(
                    widget.badge.icon,
                    size: widget.size * 0.5,
                    color: Colors.white,
                  ),
                ),
              ),

              // Candado pequeño si no está ganada
              if (!widget.isEarned)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: Icon(Icons.lock,
                        size: widget.size * 0.25, color: Colors.grey),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          // Nombre de la insignia
          Text(
            widget.badge.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: widget.size * 0.18,
              fontWeight: FontWeight.bold,
              color: widget.isEarned ? IslaColors.oceanDark : Colors.grey,
              fontFamily: 'Nunito', // Usando tu fuente del pubspec
            ),
          ),
        ],
      ),
    );
}
