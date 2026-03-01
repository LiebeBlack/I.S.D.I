import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isla_digital/core/theme/app_theme.dart';
import 'package:isla_digital/domain/models/badge.dart';
import 'package:isla_digital/domain/models/child_profile.dart';
import 'package:isla_digital/presentation/providers/app_providers.dart';
import 'package:isla_digital/presentation/widgets/badge_card.dart';
import 'package:isla_digital/presentation/widgets/big_button.dart';
import 'package:isla_digital/presentation/widgets/glass_container.dart';
import 'package:isla_digital/presentation/widgets/island_background.dart';
import 'package:isla_digital/presentation/widgets/safe_lottie.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileProvider);
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width <= 360;

    return Scaffold(
      body: IslandBackground(
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                   _buildTopBar(context, profile),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Column(
                        children: [
                          _buildWelcomeHero(context, isSmallScreen),
                          const SizedBox(height: 32),
                          _buildActionsGrid(context, ref),
                          const SizedBox(height: 120), // Space for bottom chars
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              _buildBottomCharacters(isSmallScreen),
              Positioned(
                top: 16,
                right: 16,
                child: _buildSettingsButton(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, ChildProfile? profile) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 80, 8),
      child: GlassContainer(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: IslaColors.sunflower,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.face_retouching_natural_rounded, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '¡HOLA!',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: IslaColors.oceanDark.withValues(alpha: 0.5),
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    profile?.name.toUpperCase() ?? 'EXPLORADOR',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: IslaColors.oceanDark,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            _buildBadgePill(profile?.earnedBadges.length ?? 0),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0);
  }

  Widget _buildBadgePill(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.stars_rounded, color: IslaColors.sunflower, size: 18),
          const SizedBox(width: 6),
          Text(
            '$count',
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: IslaColors.oceanDark,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeHero(BuildContext context, bool isSmallScreen) {
    return Column(
      children: [
        const SafeLottie(
          path: 'assets/animations/ui/welcome_island.json',
          backupIcon: Icons.beach_access_rounded,
          size: 180,
        ),
        const SizedBox(height: 16),
        Text(
          'ISLA DIGITAL',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: IslaColors.oceanDark,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
        ),
        Text(
          '¡TU AVENTURA COMIENZA AQUÍ!',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: IslaColors.oceanDark.withValues(alpha: 0.5),
            letterSpacing: 0.5,
          ),
        ),
      ],
    ).animate().scale(delay: 200.ms, curve: Curves.easeOutBack, duration: 800.ms);
  }

  Widget _buildActionsGrid(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        BigButton(
          icon: Icons.play_arrow_rounded,
          label: 'JUGAR',
          color: IslaColors.jungleGreen,
          onPressed: () => Navigator.pushNamed(context, '/levels'),
        ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.1, end: 0),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: BigButton(
                icon: Icons.emoji_events_rounded,
                label: 'LOGROS',
                color: IslaColors.sunflower,
                onPressed: () => _showBadgesDialog(context, ref),
              ).animate().fadeIn(delay: 600.ms).slideX(begin: -0.1, end: 0),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: BigButton(
                icon: Icons.auto_awesome_mosaic_rounded,
                label: 'ÁLBUM',
                color: IslaColors.oceanBlue,
                onPressed: () => Navigator.pushNamed(context, '/showcase'),
              ).animate().fadeIn(delay: 600.ms).slideX(begin: 0.1, end: 0),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomCharacters(bool isSmallScreen) {
    return const Positioned(
      bottom: -20,
      left: 0,
      right: 0,
      child: IgnorePointer(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SafeLottie(
              path: 'assets/animations/characters/giraffe_hello.json',
              backupIcon: Icons.face_rounded,
            ),
            SafeLottie(
              path: 'assets/animations/characters/cat_wave.json',
              backupIcon: Icons.pets_rounded,
              size: 130,
            ),
          ],
        ),
      ),
    ).animate().slideY(begin: 0.5, end: 0, delay: 800.ms, curve: Curves.easeOut);
  }

  Widget _buildSettingsButton(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.3),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 1.5),
      ),
      child: IconButton(
        icon: const Icon(Icons.settings_rounded, color: IslaColors.oceanDark),
        onPressed: () => _showSettingsMenu(context),
      ),
    );
  }

  void _showSettingsMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        title: const Text('ZONA DE PADRES', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w900)),
        content: const Text('Para entrar a los ajustes, necesitas permiso de un adulto.', textAlign: TextAlign.center),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('VOLVER'),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/parental');
                  },
                  child: const Text('ENTRAR'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showBadgesDialog(BuildContext context, WidgetRef ref) {
    final profile = ref.read(currentProfileProvider);
    final earnedIds = profile?.earnedBadges ?? [];

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (p1, p2, p3) => Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          child: GlassContainer(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'TUS TROFEOS',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: IslaColors.oceanDark),
                ),
                const SizedBox(height: 24),
                Flexible(
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: IslaBadges.allBadges.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                    ),
                    itemBuilder: (context, index) {
                      final badge = IslaBadges.allBadges[index];
                      final isEarned = earnedIds.contains(badge.id);
                      return BadgeCard(badge: badge, isEarned: isEarned);
                    },
                  ),
                ),
                const SizedBox(height: 24),
                BigButton(
                  icon: Icons.check_circle_rounded,
                  label: '¡GENIAL!',
                  color: IslaColors.jungleGreen,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}