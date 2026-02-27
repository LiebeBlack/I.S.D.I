import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../core/models/badge.dart';
import '../../core/models/child_profile.dart';
import '../../core/providers/app_providers.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/badge_card.dart';
import '../widgets/big_button.dart';
import '../widgets/island_background.dart';
import '../widgets/glass_container.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileProvider);
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width <= 360;

    return Scaffold(
      body: IslandBackground(
        showDecorations: true,
        child: SafeArea(
          child: Stack(
            children: [
              // --- Z-Index 1: Dedicated Animation Area (Bottom) ---
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: isSmallScreen ? 120 : 180,
                child: IgnorePointer(
                  child: Stack(
                    children: [
                      Positioned(
                        left: -10,
                        bottom: -10,
                        width: isSmallScreen ? 120 : 160,
                        child: Lottie.asset(
                          'assets/animations/characters/Meditating Giraffe.json',
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 10,
                        width: isSmallScreen ? 100 : 140,
                        child: Lottie.asset(
                          'assets/animations/characters/Cat Movement.json',
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // --- Z-Index 2: Main Content with Glassmorphism ---
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 12 : 20,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    _buildHeader(context, profile),
                    const SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: GlassContainer(
                          padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildWelcomeCard(context, profile, isSmallScreen),
                              const SizedBox(height: 24),
                              _buildMainActions(context, ref, isSmallScreen),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Space for bottom animations
                    SizedBox(height: isSmallScreen ? 80 : 120),
                  ],
                ),
              ),

              // --- Z-Index 3: Top-Right Discrete Controls ---
              Positioned(
                top: 10,
                right: 10,
                child: _buildDiscreteControls(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDiscreteControls(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: IconButton(
        icon: const Icon(Icons.settings, color: IslaColors.oceanDark),
        onPressed: () => _showSettingsMenu(context),
        tooltip: 'Configuración y Control Parental',
      ),
    );
  }

  void _showSettingsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => GlassContainer(
        borderRadius: 30,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.lock, color: IslaColors.sunsetPurple),
              title: const Text(
                'Control Parental',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/parental');
              },
            ),
            const Divider(color: Colors.white24),
            ListTile(
              leading: const Icon(Icons.person, color: IslaColors.oceanBlue),
              title: const Text(
                'Mi Perfil',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/profile');
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ChildProfile? profile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundColor: IslaColors.sunYellow,
              child: Icon(
                Icons.person,
                size: 28,
                color: IslaColors.oceanBlue,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¡Hola!',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: IslaColors.oceanDark,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  profile?.name ?? 'Explorador',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: IslaColors.oceanBlue,
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ],
            ),
          ],
        ),
        _buildBadgeCounter(context, profile),
        // Spacer for the top-right button
        const SizedBox(width: 48),
      ],
    );
  }

  Widget _buildBadgeCounter(BuildContext context, ChildProfile? profile) {
    final badgeCount = profile?.earnedBadges.length ?? 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: IslaColors.sunYellow.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, color: Color(0xFFE67E22), size: 18),
          const SizedBox(width: 4),
          Text(
            '$badgeCount',
            style: const TextStyle(
              color: Color(0xFFE67E22),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context, ChildProfile? profile, bool isSmallScreen) {
    return Column(
      children: [
        const Icon(
          Icons.wb_sunny,
          size: 42,
          color: IslaColors.sunYellow,
        ),
        const SizedBox(height: 12),
        Text(
          '¡Bienvenido a Isla Digital!',
          style: (isSmallScreen
                  ? Theme.of(context).textTheme.titleLarge
                  : Theme.of(context).textTheme.headlineSmall)
              ?.copyWith(
            color: IslaColors.oceanDark,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Descubre los secretos de tu teléfono como un explorador de Margarita',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: IslaColors.oceanDark.withOpacity(0.8),
                fontWeight: FontWeight.w600,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildMainActions(BuildContext context, WidgetRef ref, bool isSmallScreen) {
    return Column(
      children: [
        BigButton(
          icon: Icons.play_circle_fill,
          label: '¡Jugar!',
          color: IslaColors.palmGreen,
          onPressed: () => Navigator.pushNamed(context, '/levels'),
        ),
        SizedBox(height: isSmallScreen ? 12 : 16),
        BigButton(
          icon: Icons.emoji_events,
          label: 'Mis Insignias',
          color: IslaColors.sunsetCoral,
          onPressed: () => _showBadgesDialog(context, ref),
        ),
        SizedBox(height: isSmallScreen ? 12 : 16),
        BigButton(
          icon: Icons.photo_library,
          label: 'Galería Secreta',
          color: IslaColors.oceanDark,
          onPressed: () => Navigator.pushNamed(context, '/showcase'),
        ),
      ],
    );
  }

  void _showBadgesDialog(BuildContext context, WidgetRef ref) {
    final profile = ref.read(currentProfileProvider);
    final earnedIds = profile?.earnedBadges ?? [];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        content: GlassContainer(
          borderRadius: 24,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Mis Insignias',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: IslaColors.oceanDark,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.maxFinite,
                child: IslaBadges.allBadges.isEmpty
                    ? const Text('¡Completa actividades para ganar insignias!')
                    : Wrap(
                        spacing: 12,
                        runSpacing: 16,
                        alignment: WrapAlignment.center,
                        children: IslaBadges.allBadges.map((badge) {
                          return BadgeCard(
                            badge: badge,
                            isEarned: earnedIds.contains(badge.id),
                            size: 55,
                          );
                        }).toList(),
                      ),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cerrar',
                  style: TextStyle(
                    color: IslaColors.oceanBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
