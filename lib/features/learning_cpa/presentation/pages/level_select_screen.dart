import 'package:flutter_animate/flutter_animate.dart';

// Núcleo y Estilo
import 'package:isla_digital/core/core.dart';

// Niveles
import 'package:isla_digital/features/learning_cpa/presentation/pages/levels/level1/level1_screen.dart';
import 'package:isla_digital/features/learning_cpa/presentation/pages/levels/level2/level2_screen.dart';

/// Modelo de datos inmutable para definir cada nivel.
class LevelConfig {
  const LevelConfig({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.screen,
  });
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Widget screen;
}

class LevelSelectScreen extends ConsumerWidget {
  const LevelSelectScreen({super.key});

  static const List<LevelConfig> _levels = [
    LevelConfig(
      id: 'level_1',
      title: 'BIENVENIDA',
      subtitle: 'HOLA TELÉFONO',
      icon: Icons.smartphone_rounded,
      color: IslaColors.oceanBlue,
      screen: Level1Screen(),
    ),
    LevelConfig(
      id: 'level_2',
      title: 'CONECTADOS',
      subtitle: 'AMIGOS SEGUROS',
      icon: Icons.forum_rounded,
      color: IslaColors.jungleGreen,
      screen: Level2Screen(),
    ),
    LevelConfig(
      id: 'level_3',
      title: 'DETECTIVE',
      subtitle: 'INTERNET GENIAL',
      icon: Icons.search_rounded,
      color: IslaColors.sunflower,
      screen: Scaffold(body: Center(child: Text('Nivel 3 Próximamente'))),
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileProvider);

    // Aseguramos que el nivel desbloqueado sea un entero
    final int currentUnlocked = (profile?.currentLevel ?? 1).toInt();

    final Map<String, dynamic> progressMap = profile?.levelProgress ?? {};

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 100),
                physics: const BouncingScrollPhysics(),
                itemCount: _levels.length,
                itemBuilder: (context, index) {
                  final level = _levels[index];
                  final isUnlocked = (index + 1) <= currentUnlocked;

                  // Forzamos que el progreso sea double para la lógica interna
                  final double progressValue =
                      ((progressMap[level.id] as num?) ?? 0).toDouble();

                  return _LevelListItem(
                    index: index,
                    level: level,
                    isUnlocked: isUnlocked,
                    progress: progressValue,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: IslaColors.oceanDark),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              'MI MAPA',
              textAlign: TextAlign.center,
              style: DynamicThemingEngine.displayStyle.copyWith(fontSize: 28),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.2);
}

class _LevelListItem extends StatelessWidget {
  const _LevelListItem({
    required this.index,
    required this.level,
    required this.isUnlocked,
    required this.progress,
  });
  final int index;
  final LevelConfig level;
  final bool isUnlocked;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = progress >= 100.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: isUnlocked
            ? () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => level.screen))
            : () => _showLockedMessage(context),
        child: GlassContainer(
          padding: const EdgeInsets.all(16),
          child: Opacity(
            opacity: isUnlocked ? 1.0 : 0.6,
            child: Row(
              children: [
                _LevelBadgeIcon(level: level, isUnlocked: isUnlocked),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        level.title,
                        style: DynamicThemingEngine.titleMediumStyle.copyWith(
                          color: isUnlocked
                              ? IslaColors.oceanDark
                              : Colors.grey[700],
                        ),
                      ),
                      Text(
                        level.subtitle,
                        style: DynamicThemingEngine.labelStyle,
                      ),
                      if (isUnlocked && progress > 0 && !isCompleted) ...[
                        const SizedBox(height: 12),
                        IslandProgressBar(
                          // CORRECCIÓN LÍNEA 181: Si IslandProgressBar pide int, convertimos aquí
                          progress: progress.toInt(),
                          height: 8,
                          fillColor: level.color,
                        ),
                      ],
                    ],
                  ),
                ),
                _StatusIndicator(
                    isUnlocked: isUnlocked,
                    isCompleted: isCompleted,
                    color: level.color),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: (index * 100).ms).slideX(begin: 0.1);
  }

  void _showLockedMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('¡Sigue jugando para desbloquear esta aventura!'),
        backgroundColor: IslaColors.oceanDark,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

// SOLUCIÓN A ERRORES DE MÉTODOS INDEFINIDOS:
// Se definen los widgets privados que faltaban al final del archivo.

class _LevelBadgeIcon extends StatelessWidget {
  const _LevelBadgeIcon({required this.level, required this.isUnlocked});
  final LevelConfig level;
  final bool isUnlocked;

  @override
  Widget build(BuildContext context) => Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: isUnlocked ? level.color : Colors.grey[300],
        borderRadius: BorderRadius.circular(18),
      ),
      child: Icon(
        isUnlocked ? level.icon : Icons.lock_rounded,
        color: isUnlocked ? Colors.white : Colors.grey[600],
        size: 30,
      ),
    );
}

class _StatusIndicator extends StatelessWidget {
  const _StatusIndicator({
    required this.isUnlocked,
    required this.isCompleted,
    required this.color,
  });
  final bool isUnlocked;
  final bool isCompleted;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (!isUnlocked) {
      return const Icon(Icons.lock_outline_rounded, color: Colors.grey);
    }

    if (isCompleted) {
      return const Icon(Icons.check_circle_rounded,
          color: IslaColors.jungleGreen, size: 36);
    }

    return Icon(Icons.play_circle_filled_rounded, color: color, size: 36);
  }
}
