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

class Level4Screen extends ConsumerStatefulWidget {
  const Level4Screen({super.key});

  @override
  ConsumerState<Level4Screen> createState() => _Level4ScreenState();
}

class _Level4ScreenState extends ConsumerState<Level4Screen> {
  int currentTab = 0;
  int totalProgress = 0;
  late ConfettiController _confettiController;

  final List<String> tabs = ['Cuenta', 'Aprende', 'Cámara'];

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _addProgress(int points) {
    setState(() {
      totalProgress += points;
      if (totalProgress >= 100) {
        _completeLevel();
      }
    });
    (ref.read(currentProfileProvider.notifier) as ProfileNotifier).addProgress('level_4', points);
  }

  void _completeLevel() {
    _confettiController.play();
    final badge = IslaBadges.getById('calculador_frutas');
    if (badge != null) {
      final notifier = ref.read(currentProfileProvider.notifier) as ProfileNotifier;
      notifier.addBadge(badge.id);
      notifier.unlockLevel(5);
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white.withValues(alpha: 0.95),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        title: const Text('¡EL REY DEL MANGO!', textAlign: TextAlign.center),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SafeLottie(
              path: 'assets/animations/success/king.json',
              backupIcon: Icons.workspace_premium_rounded,
            ),
            SizedBox(height: 16),
            Text('¡Completaste todas las Súper Tareas!'),
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
                    child: IslandProgressBar(
                      progress: totalProgress.clamp(0, 100),
                      label: 'Progreso de Nivel',
                      fillColor: IslaColors.coralReef,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTabBar(),
                  const SizedBox(height: 16),
                  Expanded(
                    child: IndexedStack(
                      index: currentTab,
                      children: [
                        CalculatorWidget(onProgress: _addProgress),
                        CalendarWidget(onProgress: _addProgress),
                        CameraMissionWidget(onProgress: _addProgress),
                      ],
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
            'SÚPER TAREAS',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: IslaColors.oceanDark,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: IslaColors.oceanBlue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = currentTab == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => currentTab = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? IslaColors.oceanBlue : Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: isSelected ? [
                    BoxShadow(color: IslaColors.oceanBlue.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))
                  ] : null,
                ),
                child: Text(
                  tabs[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : IslaColors.charcoal.withValues(alpha: 0.5),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class CalculatorWidget extends StatefulWidget {
  const CalculatorWidget({super.key, required this.onProgress});
  final Function(int) onProgress;

  @override
  State<CalculatorWidget> createState() => _CalculatorWidgetState();
}

class _CalculatorWidgetState extends State<CalculatorWidget> {
  int num1 = 2;
  int num2 = 3;
  int correctCount = 0;

  int get index => (num1 + num2) % 5;

  void _checkAnswer(int selected) {
    if (selected == num1 + num2) {
      widget.onProgress(20);
      setState(() {
        correctCount++;
        num1 = (num1 * 3 + 1) % 5 + 1;
        num2 = (num2 * 2 + 1) % 4 + 1;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Casi! Intenta contar de nuevo')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          GlassContainer(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNumberVisual(num1, Icons.auto_awesome_rounded, IslaColors.sunflower),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text('+', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900)),
                ),
                _buildNumberVisual(num2, Icons.auto_awesome_rounded, IslaColors.oceanBlue),
              ],
            ),
          ).animate().fadeIn().scale(),
          const SizedBox(height: 40),
          const Text('¿CUÁNTOS HAY EN TOTAL?', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5)),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: List.generate(8, (i) {
              final val = i + 2;
              return GestureDetector(
                onTap: () => _checkAnswer(val),
                child: SizedBox(
                  width: 70,
                  height: 70,
                  child: GlassContainer(
                    padding: EdgeInsets.zero,
                    child: Center(
                      child: Text('$val', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                    ),
                  ),
                ),
              );
            }),
          ).animate().fadeIn().scale(),
        ],
      ),
    );
  }

  Widget _buildNumberVisual(int count, IconData icon, Color color) {
    return Column(
      children: [
        Wrap(
          spacing: 4,
          children: List.generate(count, (_) => Icon(icon, color: color, size: 24)),
        ),
        const SizedBox(height: 8),
        Text('$count', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
      ],
    );
  }
}

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key, required this.onProgress});
  final Function(int) onProgress;

  final List<Map<String, dynamic>> events = const [
    {'day': '15', 'month': 'FEB', 'title': 'Fiesta del Mar', 'icon': Icons.waves_rounded},
    {'day': '25', 'month': 'MAR', 'title': 'Día del Pescador', 'icon': Icons.set_meal_rounded},
    {'day': '08', 'month': 'MAY', 'title': 'Festival del Sol', 'icon': Icons.wb_sunny_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final e = events[index];
        return GestureDetector(
          onTap: () {
            onProgress(10);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('¡Evento aprendido!')));
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GlassContainer(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(color: IslaColors.coralReef.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(e['day']! as String, style: const TextStyle(fontWeight: FontWeight.w900, color: IslaColors.coralReef)),
                        Text(e['month']! as String, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: Text(e['title']! as String, style: const TextStyle(fontWeight: FontWeight.w800))),
                  Icon(e['icon']! as IconData, color: IslaColors.coralReef),
                ],
              ),
            ),
          ),
        ).animate().slideX(begin: 0.2, delay: (index * 100).ms);
      },
    );
  }
}

class CameraMissionWidget extends StatefulWidget {
  const CameraMissionWidget({super.key, required this.onProgress});
  final Function(int) onProgress;

  @override
  State<CameraMissionWidget> createState() => _CameraMissionWidgetState();
}

class _CameraMissionWidgetState extends State<CameraMissionWidget> {
  final List<Map<String, dynamic>> missions = [
    {'target': 'Algo Azul', 'icon': Icons.color_lens_rounded, 'done': false},
    {'target': 'Una Flor', 'icon': Icons.local_florist_rounded, 'done': false},
    {'target': 'Un Juguete', 'icon': Icons.toys_rounded, 'done': false},
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16),
      itemCount: missions.length,
      itemBuilder: (context, index) {
        final m = missions[index];
        return GestureDetector(
          onTap: () {
            setState(() => m['done'] = true);
            widget.onProgress(20);
          },
          child: GlassContainer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon((m['done'] as bool) ? Icons.check_circle_rounded : (m['icon'] as IconData), size: 48, color: (m['done'] as bool) ? IslaColors.jungleGreen : IslaColors.coralReef),
                const SizedBox(height: 12),
                Text(m['target'] as String, style: const TextStyle(fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ).animate().fadeIn(delay: (index * 100).ms);
      },
    );
  }
}
