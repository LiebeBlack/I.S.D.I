import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isla_digital/core/theme/app_theme.dart';
import 'package:isla_digital/domain/models/badge.dart';
import 'package:isla_digital/presentation/providers/app_providers.dart';
import 'package:isla_digital/presentation/widgets/glass_container.dart';
import 'package:isla_digital/presentation/widgets/island_background.dart';
import 'package:isla_digital/presentation/widgets/progress_widgets.dart';
import 'package:isla_digital/presentation/widgets/safe_lottie.dart';

class Level3Screen extends ConsumerStatefulWidget {
  const Level3Screen({super.key});

  @override
  ConsumerState<Level3Screen> createState() => _Level3ScreenState();
}

class _Level3ScreenState extends ConsumerState<Level3Screen> {
  int currentStep = 0;
  int score = 0;
  late ConfettiController _confettiController;
  final PageController _pageController = PageController();

  final List<Map<String, dynamic>> rounds = [
    {
      'scenario': '¡Quiero ver gatitos graciosos!',
      'websites': [
        {'name': 'GatitosBuenos.com', 'icon': Icons.pets_rounded, 'safe': true},
        {'name': 'PremiosGratis.xyz', 'icon': Icons.warning_rounded, 'safe': false},
        {'name': 'VideosDeAnimales.edu', 'icon': Icons.video_library_rounded, 'safe': true},
      ],
    },
    {
      'scenario': 'Busco dibujos para colorear',
      'websites': [
        {'name': 'DibujosLindos.app', 'icon': Icons.brush_rounded, 'safe': true},
        {'name': 'DescargaVirus.net', 'icon': Icons.download_rounded, 'safe': false},
        {'name': 'MundoColor.org', 'icon': Icons.palette_rounded, 'safe': true},
      ],
    },
    {
      'scenario': 'Quiero jugar un ratito',
      'websites': [
        {'name': 'IslaDeJuegos.gob', 'icon': Icons.sports_esports_rounded, 'safe': true},
        {'name': 'GanaDineroPronto', 'icon': Icons.monetization_on_rounded, 'safe': false},
        {'name': 'DiversionSegura.com', 'icon': Icons.celebration_rounded, 'safe': true},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _selectSite(bool isSafe, String name) {
    if (isSafe) {
      setState(() {
        score += 50;
        if (currentStep < rounds.length - 1) {
          currentStep++;
          _pageController.nextPage(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutBack,
          );
        } else {
          _completeLevel();
        }
      });
      ref.read(currentProfileProvider.notifier).addProgress('level_3', 50);
    } else {
      _showDangerDialog(name);
    }
  }

  void _showDangerDialog(String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('¡DETENTE, DETECTIVE!'),
        content: Text('$name parece una trampa. Los sitios con nombres extraños o premios falsos pueden ser peligrosos.'),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('¡ENTENDIDO!'),
            ),
          )
        ],
      ),
    );
  }

  void _completeLevel() {
    _confettiController.play();
    final badge = IslaBadges.getById('detective_seguro');
    if (badge != null) {
      ref.read(currentProfileProvider.notifier).addBadge(badge.id);
    }
    ref.read(currentProfileProvider.notifier).unlockLevel(4);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white.withValues(alpha: 0.95),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        title: const Text('¡SÚPER DETECTIVE!', textAlign: TextAlign.center),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SafeLottie(
              path: 'assets/animations/success/detective.json',
              backupIcon: Icons.search_rounded,
            ),
            SizedBox(height: 16),
            Text('¡Identificaste todos los peligros!'),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('VOLVER AL MAPA'),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          IslandBackground(
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: StepIndicator(
                      currentStep: currentStep,
                      totalSteps: rounds.length,
                      activeColor: IslaColors.royalPurple,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: rounds.length,
                      itemBuilder: (context, index) => _buildGameContent(rounds[index]),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            colors: const [IslaColors.oceanBlue, IslaColors.sunflower, IslaColors.jungleGreen, IslaColors.sunsetPink],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close_rounded, color: IslaColors.oceanDark, size: 32),
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          Text(
            'DETECTIVE',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: IslaColors.oceanDark,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: IslaColors.sunflower,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$score',
              style: const TextStyle(fontWeight: FontWeight.w900, color: IslaColors.oceanDark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameContent(Map<String, dynamic> round) {
    final websites = round['websites'] as List<dynamic>;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          GlassContainer(
            child: Column(
              children: [
                const Icon(Icons.search_rounded, size: 48, color: IslaColors.royalPurple),
                const SizedBox(height: 12),
                Text(
                  round['scenario'] as String,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ).animate().fadeIn().scale(),
          const SizedBox(height: 32),
          Text(
            '¿CUÁL SITIO ES SEGURO?',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              letterSpacing: 2,
              fontWeight: FontWeight.w900,
              color: IslaColors.charcoal.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              itemCount: websites.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final site = websites[index] as Map<String, dynamic>;
                return _buildWebsiteCard(
                  site['name']! as String,
                  site['icon']! as IconData,
                  site['safe']! as bool,
                ).animate().slideX(begin: 0.2, delay: (index * 100).ms, curve: Curves.easeOutBack);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebsiteCard(String name, IconData icon, bool safe) {
    return GestureDetector(
      onTap: () => _selectSite(safe, name),
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: safe ? IslaColors.jungleGreen.withValues(alpha: 0.1) : IslaColors.coralReef.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: safe ? IslaColors.jungleGreen : IslaColors.coralReef),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            Icon(
              safe ? Icons.verified_user_rounded : Icons.warning_amber_rounded,
              color: safe ? IslaColors.jungleGreen : IslaColors.coralReef,
            ),
          ],
        ),
      ),
    );
  }
}
