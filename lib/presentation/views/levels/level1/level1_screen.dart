import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isla_digital/core/theme/app_theme.dart';
import 'package:isla_digital/presentation/widgets/glass_container.dart';
import 'package:isla_digital/presentation/widgets/island_background.dart';
import 'package:isla_digital/presentation/widgets/progress_widgets.dart';
import 'package:isla_digital/presentation/widgets/safe_lottie.dart';

class Level1Screen extends ConsumerStatefulWidget {
  const Level1Screen({super.key});

  @override
  ConsumerState<Level1Screen> createState() => _Level1ScreenState();
}

class _Level1ScreenState extends ConsumerState<Level1Screen> {
  int currentStep = 0;
  late ConfettiController _confettiController;
  final PageController _pageController = PageController();

  final List<Map<String, dynamic>> steps = [
    {
      'title': '¡Hola, Amiguito!',
      'instruction': 'Toca el botón brillante para despertar la isla',
      'type': 'power',
      'icon': Icons.power_settings_new,
      'lottie': 'assets/animations/ui/power.json',
      'color': IslaColors.oceanBlue,
    },
    {
      'title': '¡Abre el Tesoro!',
      'instruction': 'Desliza hacia arriba como una ola saltarina',
      'type': 'swipe',
      'icon': Icons.expand_less,
      'lottie': 'assets/animations/ui/swipe_up.json',
      'color': IslaColors.sunflower,
    },
    {
      'title': '¡Cuida tu Isla!',
      'instruction': 'Toca el escudo para proteger tu tesoro digital',
      'type': 'care',
      'icon': Icons.security,
      'lottie': 'assets/animations/ui/shield.json',
      'color': IslaColors.jungleGreen,
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

  void _onStepCompleted() {
    if (currentStep < steps.length - 1) {
      setState(() => currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutBack,
      );
    } else {
      _showFinalCelebration();
    }
  }

  void _showFinalCelebration() {
    _confettiController.play();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white.withValues(alpha: 0.95),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        title: Text(
          '¡ERES UN SUPERHÉROE!',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: IslaColors.oceanDark,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SafeLottie(
              path: 'assets/animations/success/pearl.json',
              backupIcon: Icons.stars,
            ),
            const SizedBox(height: 16),
            Text(
              '¡Ganaste la Perla de Sabiduría!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
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
            ).animate().shimmer(delay: 500.ms, duration: 1500.ms),
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
                      totalSteps: steps.length,
                      activeColor: steps[currentStep]['color'] as Color,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: steps.length,
                      itemBuilder: (context, index) => _buildStep(steps[index]),
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
            'PASO ${currentStep + 1} DE ${steps.length}',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: IslaColors.charcoal.withValues(alpha: 0.5),
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildStep(Map<String, dynamic> step) {
    final color = step['color'] as Color;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            step['title'] as String,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: IslaColors.oceanDark,
              fontWeight: FontWeight.w900,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn().scale(curve: Curves.easeOutBack),
          
          const SizedBox(height: 40),
          
          GestureDetector(
            onTap: _onStepCompleted,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withValues(alpha: 0.1),
                  ),
                ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                 .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 2.seconds),
                 
                SafeLottie(
                  path: step['lottie'] as String,
                  backupIcon: step['icon'] as IconData,
                  size: 160,
                ),
              ],
            ),
          ).animate().fadeIn(delay: 300.ms).moveY(begin: 20, end: 0),
          
          const SizedBox(height: 50),
          
          GlassContainer(
            padding: const EdgeInsets.all(24),
            child: Text(
              step['instruction'] as String,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: IslaColors.charcoal,
                fontWeight: FontWeight.w700,
              ),
            ),
          ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2, end: 0),
        ],
      ),
    );
  }
}