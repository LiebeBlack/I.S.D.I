import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isla_digital/core/theme/app_theme.dart';
import 'package:isla_digital/presentation/providers/app_providers.dart';
import 'package:isla_digital/presentation/views/levels/level1/level1_screen.dart';
import 'package:isla_digital/presentation/views/levels/level2/level2_screen.dart';
import 'package:isla_digital/presentation/views/levels/level3/level3_screen.dart';
import 'package:isla_digital/presentation/views/levels/level4/level4_screen.dart';
import 'package:isla_digital/presentation/views/levels/level5/level5_screen.dart';
import 'package:isla_digital/presentation/widgets/glass_container.dart';
import 'package:isla_digital/presentation/widgets/island_background.dart';
import 'package:isla_digital/presentation/widgets/progress_widgets.dart';

class LevelSelectScreen extends ConsumerWidget {
  const LevelSelectScreen({super.key});

  static const List<Map<String, dynamic>> levels = [
    {
      'id': 'level_1',
      'title': 'BIENVENIDA',
      'subtitle': 'HOLA TELÉFONO',
      'icon': Icons.smartphone_rounded,
      'color': IslaColors.oceanBlue,
    },
    {
      'id': 'level_2',
      'title': 'CONECTADOS',
      'subtitle': 'AMIGOS SEGUROS',
      'icon': Icons.forum_rounded,
      'color': IslaColors.jungleGreen,
    },
    {
      'id': 'level_3',
      'title': 'DETECTIVE',
      'subtitle': 'INTERNET GENIAL',
      'icon': Icons.search_rounded,
      'color': IslaColors.sunflower,
    },
    {
      'id': 'level_4',
      'title': 'MAESTRO',
      'subtitle': 'SÚPER TAREAS',
      'icon': Icons.auto_stories_rounded,
      'color': IslaColors.coralReef,
    },
    {
      'id': 'level_5',
      'title': 'ARTISTA',
      'subtitle': 'PINTA Y TOCA',
      'icon': Icons.palette_rounded,
      'color': IslaColors.sunsetPink,
    },
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileProvider);
    final currentLevelProgress = profile?.currentLevel ?? 1;

    return Scaffold(
      body: IslandBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  physics: const BouncingScrollPhysics(),
                  itemCount: levels.length,
                  itemBuilder: (context, index) {
                    final level = levels[index];
                    final isUnlocked = (index + 1) <= currentLevelProgress;
                    final progress = profile?.levelProgress[level['id']] ?? 0;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: _buildLevelItem(context, level, isUnlocked, progress),
                    ).animate().fadeIn(delay: (index * 100).ms).slideX(begin: 0.1, end: 0);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: IslaColors.oceanDark),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const Expanded(
            child: Text(
              'EL MAPA',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: IslaColors.oceanDark,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(width: 48), // Balance
        ],
      ),
    );
  }

  Widget _buildLevelItem(BuildContext context, Map<String, dynamic> level, bool isUnlocked, int progress) {
    final color = level['color'] as Color;

    return GestureDetector(
      onTap: isUnlocked ? () => _navigateToLevel(context, level['id'] as String) : null,
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: isUnlocked ? color : IslaColors.charcoal.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                boxShadow: isUnlocked ? [
                  BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4)),
                ] : [],
              ),
              child: Icon(
                isUnlocked ? (level['icon'] as IconData) : Icons.lock_rounded,
                color: isUnlocked ? Colors.white : IslaColors.charcoal.withValues(alpha: 0.3),
                size: 32,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    level['title'] as String,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: isUnlocked ? IslaColors.oceanDark : IslaColors.charcoal.withValues(alpha: 0.3),
                    ),
                  ),
                  Text(
                    level['subtitle'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: isUnlocked ? IslaColors.oceanDark.withValues(alpha: 0.5) : IslaColors.charcoal.withValues(alpha: 0.2),
                    ),
                  ),
                  if (isUnlocked && progress > 0) ...[
                    const SizedBox(height: 12),
                    IslandProgressBar(
                      progress: progress,
                      height: 10,
                      fillColor: color,
                      showPercentage: false,
                    ),
                  ],
                ],
              ),
            ),
            if (isUnlocked && progress >= 100)
              const Icon(Icons.stars_rounded, color: IslaColors.sunflower, size: 32)
            else if (isUnlocked)
              Icon(Icons.play_circle_filled_rounded, color: color.withValues(alpha: 0.8), size: 32),
          ],
        ),
      ),
    );
  }

  void _navigateToLevel(BuildContext context, String levelId) {
    final Map<String, Widget> levelScreens = {
      'level_1': const Level1Screen(),
      'level_2': const Level2Screen(),
      'level_3': const Level3Screen(),
      'level_4': const Level4Screen(),
      'level_5': const Level5Screen(),
    };

    final screen = levelScreens[levelId];
    if (screen != null) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
    }
  }
}