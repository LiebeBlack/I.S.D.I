import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:isla_digital/core/theme/app_theme.dart';
import 'package:isla_digital/presentation/providers/app_providers.dart';
import 'package:isla_digital/presentation/widgets/big_button.dart';
import 'package:isla_digital/presentation/widgets/glass_container.dart';
import 'package:isla_digital/presentation/widgets/safe_lottie.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TIPADO ESTRICTO: Accedemos al perfil
    final profile = ref.watch(currentProfileProvider);
    
    // CORRECCIÓN: Conversión explícita y manejo de nulos
    // Forzamos el cast a String y List<String> para evitar el error de dynamic
    final String profileName = (profile?.name as String?) ?? 'Explorador';
    final List<String> earnedBadges = List<String>.from(profile?.earnedBadges ?? []);
    
    final size = MediaQuery.sizeOf(context);
    final isSmallScreen = size.height < 400;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: _TopBar(name: profileName, badgesCount: earnedBadges.length),
                ),
                
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        const _WelcomeHero(),
                        const SizedBox(height: 30),
                        _ActionsGrid(earnedBadges: earnedBadges),
                        const Spacer(),
                        const SizedBox(height: 120), 
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            _BottomCharacters(isSmallScreen: isSmallScreen),
            
            Positioned(
              top: 16,
              right: 16,
              child: _SettingsButton(onPressed: () => _showSettingsMenu(context)),
            ),
          ],
        ),
      ),
    );
  }

  void _showSettingsMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        title: Text('ZONA DE PADRES', 
          textAlign: TextAlign.center, 
          style: IslaThemes.titleMediumStyle.copyWith(color: IslaColors.oceanDark)),
        content: const Text('¿Deseas entrar a la configuración parental?', textAlign: TextAlign.center),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCELAR'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: IslaColors.oceanBlue, 
              foregroundColor: Colors.white,
              shape: const StadiumBorder(),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/parental');
            },
            child: const Text('ENTRAR'),
          ),
        ],
      ),
    );
  }
}

// --- SUB-WIDGETS ---

class _TopBar extends StatelessWidget {
  const _TopBar({required this.name, required this.badgesCount});
  final String name;
  final int badgesCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 80, 8),
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            const Hero(
              tag: 'profile_avatar',
              child: _AvatarCircle(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('¡HOLA!', style: IslaThemes.labelStyle),
                  Text(
                    name.toUpperCase(),
                    style: IslaThemes.titleMediumStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            _BadgePill(count: badgesCount),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0);
  }
}

class _AvatarCircle extends StatelessWidget {
  const _AvatarCircle();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: IslaColors.sunflower,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.face_retouching_natural_rounded, color: Colors.white, size: 24),
    );
  }
}

class _BadgePill extends StatelessWidget {
  const _BadgePill({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.stars_rounded, color: IslaColors.sunflower, size: 18),
          const SizedBox(width: 6),
          Text('$count', style: IslaThemes.badgeCounterStyle),
        ],
      ),
    );
  }
}

class _WelcomeHero extends StatelessWidget {
  const _WelcomeHero();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SafeLottie(
          path: 'assets/animations/ui/welcome_island.json',
          size: 180,
        ),
        Text('ISLA DIGITAL', style: IslaThemes.displayStyle),
        Text('¡TU AVENTURA COMIENZA AQUÍ!', style: IslaThemes.subtitleStyle),
      ],
    ).animate().scale(delay: 200.ms, curve: Curves.easeOutBack);
  }
}

class _ActionsGrid extends StatelessWidget {
  const _ActionsGrid({required this.earnedBadges});
  final List<String> earnedBadges;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BigButton(
          icon: Icons.play_arrow_rounded,
          label: 'JUGAR',
          color: IslaColors.jungleGreen,
          onPressed: () => Navigator.pushNamed(context, '/levels'),
        ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.1),
        
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: BigButton(
                icon: Icons.emoji_events_rounded,
                label: 'LOGROS',
                color: IslaColors.sunflower,
                onPressed: () => _showBadgesDialog(context, earnedBadges),
              ).animate().fadeIn(delay: 550.ms).slideX(begin: -0.1),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: BigButton(
                icon: Icons.auto_awesome_mosaic_rounded,
                label: 'ÁLBUM',
                color: IslaColors.oceanBlue,
                onPressed: () => Navigator.pushNamed(context, '/showcase'),
              ).animate().fadeIn(delay: 700.ms).slideX(begin: 0.1),
            ),
          ],
        ),
      ],
    );
  }

  void _showBadgesDialog(BuildContext context, List<String> earned) {
     showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('TUS MEDALLAS'),
        content: Text('Has ganado ${earned.length} medallas en tus aventuras.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('¡GENIAL!'))
        ],
      ),
    );
  }
}

class _BottomCharacters extends StatelessWidget {
  const _BottomCharacters({required this.isSmallScreen});
  final bool isSmallScreen;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: -10,
      left: 0,
      right: 0,
      child: IgnorePointer(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SafeLottie(path: 'assets/animations/characters/giraffe_hello.json', size: 130),
            SafeLottie(
              path: 'assets/animations/characters/cat_wave.json',
              size: isSmallScreen ? 100 : 130,
            ),
          ],
        ),
      ),
    ).animate().slideY(begin: 0.5, end: 0, delay: 800.ms);
  }
}

class _SettingsButton extends StatelessWidget {
  const _SettingsButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.3),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
          ),
          child: const Icon(Icons.settings_rounded, color: IslaColors.oceanDark),
        ),
      ),
    );
  }
}