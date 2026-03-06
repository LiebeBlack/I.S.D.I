import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:isla_digital/core/core.dart';

class SpecialEventLevel extends ConsumerStatefulWidget {
  const SpecialEventLevel({super.key});

  @override
  ConsumerState<SpecialEventLevel> createState() => _SpecialEventLevelState();
}

class _SpecialEventLevelState extends ConsumerState<SpecialEventLevel> {
  final ConfettiController _confetti =
      ConfettiController(duration: const Duration(seconds: 3));
  int _score = 0;
  final int _targetScore = 15;
  final List<Offset> _stars = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _spawnStars();
  }

  void _spawnStars() {
    _stars.clear();
    for (int i = 0; i < 5; i++) {
      _addRandomStar();
    }
  }

  void _addRandomStar() {
    // Coordinates normalized from 0.1 to 0.9 to stay within screen
    _stars.add(Offset(
      0.1 + _random.nextDouble() * 0.8,
      0.2 + _random.nextDouble() * 0.6,
    ));
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  void _catchStar(Offset pos) {
    if (!mounted) return;
    setState(() {
      if (!_stars.remove(pos)) return; // Blindaje (Zero-Errors)
      _score++;
      if (_score < _targetScore) {
        _addRandomStar();
      } else if (_score == _targetScore) {
        _confetti.play();
        // Celebration triggered via local confetti for now
        ref
            .read(currentProfileProvider.notifier)
            .addProgress('event_spring_2026', 150);
        ref
            .read(currentProfileProvider.notifier)
            .addBadge('star_catcher_expert');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isFinished = _score >= _targetScore;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: IslaColors.charcoal),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24),
            child: Chip(
              backgroundColor: IslaColors.sunflower,
              label: Text('$_score / $_targetScore',
                  style: DynamicThemingEngine.titleMediumStyle),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          // Dynamic gradient background for event
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [IslaColors.royalPurple, IslaColors.oceanBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          if (!isFinished)
            ...List.generate(_stars.length, (index) {
              final pos = _stars[index];
              return Positioned(
                left: MediaQuery.sizeOf(context).width * pos.dx,
                top: MediaQuery.sizeOf(context).height * pos.dy,
                child: GestureDetector(
                  onTap: () => _catchStar(pos),
                  child: const SafeLottie(
                    path: 'assets/animations/ui/star.json',
                    size: 80, // Needs highly visible items
                  )
                      .animate(
                          onPlay: (controller) =>
                              controller.repeat(reverse: true))
                      .slideY(begin: -0.1, end: 0.1, duration: 1000.ms),
                ),
              );
            }),

          if (isFinished)
            Center(
              child: GlassContainer(
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('¡EVENTO COMPLETADO!', style: DynamicThemingEngine.displayStyle),
                    const SizedBox(height: 16),
                    Text('+150 Puntos',
                        style: DynamicThemingEngine.titleMediumStyle
                            .copyWith(color: IslaColors.jungleGreen)),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: IslaColors.sunflower),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('VOLVER A LA ISLA',
                          style: TextStyle(color: IslaColors.charcoal)),
                    )
                  ],
                ),
              ).animate().scale(curve: Curves.easeOutBack),
            ),

          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confetti,
              blastDirectionality: BlastDirectionality.explosive,
              colors: const [
                IslaColors.sunflower,
                IslaColors.tropicOrange,
                IslaColors.sunsetPink
              ],
            ),
          ),
        ],
      ),
    );
  }
}
