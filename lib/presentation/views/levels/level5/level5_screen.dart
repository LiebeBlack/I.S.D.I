import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isla_digital/core/theme/app_theme.dart';
import 'package:isla_digital/domain/models/models.dart'; 
import 'package:isla_digital/presentation/providers/app_providers.dart';
import 'package:isla_digital/presentation/widgets/island_background.dart';
import 'package:isla_digital/presentation/widgets/progress_widgets.dart';
import 'package:isla_digital/presentation/widgets/safe_lottie.dart';

import 'widgets/drawing_canvas.dart';
import 'widgets/music_sequencer.dart';

class Level5Screen extends ConsumerStatefulWidget {
  const Level5Screen({super.key});

  @override
  ConsumerState<Level5Screen> createState() => _Level5ScreenState();
}

class _Level5ScreenState extends ConsumerState<Level5Screen> {
  int currentTab = 0;
  int totalProgress = 0;
  bool isCompleted = false;
  late ConfettiController _confettiController;

  final List<String> tabs = ['Pintar', 'Música'];

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

  void _handleProgress(int points) {
    if (isCompleted) return;
    
    setState(() {
      totalProgress += points;
      if (totalProgress >= 100) {
        totalProgress = 100;
        isCompleted = true;
        _completeLevel();
      }
    });
    
    ref.read(currentProfileProvider.notifier).addProgress('level_5', points);
  }

  void _completeLevel() {
    _confettiController.play();
    final notifier = ref.read(currentProfileProvider.notifier);
    
    notifier.addBadge('artist_master');
    notifier.addBadge('musician_tropical');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white.withValues(alpha: 0.95),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        title: const Text(
          '¡GRAN ARTISTA!', 
          textAlign: TextAlign.center, 
          style: TextStyle(fontWeight: FontWeight.w900)
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SafeLottie(
              path: 'assets/animations/success/artist.json',
              backupIcon: Icons.palette_rounded,
            ),
            SizedBox(height: 16),
            Text(
              '¡Tus creaciones son maravillosas!',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: IslaColors.jungleGreen),
              onPressed: () {
                Navigator.pop(context); 
                Navigator.pop(context); 
              },
              child: const Text('VOLVER AL MAPA', style: TextStyle(color: Colors.white)),
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
                      // CORRECCIÓN: Se asegura el tipo de dato correcto. 
                      // Si el error decía que pasabas double a int, usa totalProgress directamente.
                      progress: totalProgress, 
                      label: 'Progreso Artístico',
                      fillColor: IslaColors.sunsetPink,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTabBar(),
                  const SizedBox(height: 16),
                  Expanded(
                    child: IndexedStack(
                      index: currentTab,
                      children: [
                        DrawingCanvas(onProgress: () => _handleProgress(10)),
                        MusicSequencer(onProgress: () => _handleProgress(10)),
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
            colors: const [
              IslaColors.oceanBlue, 
              IslaColors.sunflower, 
              IslaColors.jungleGreen, 
              IslaColors.sunsetPink
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close_rounded, color: IslaColors.oceanDark, size: 32),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              'ISLA DEL ARTE',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: IslaColors.oceanDark,
                fontWeight: FontWeight.w900,
                fontSize: 22,
              ),
            ),
          ),
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
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      index == 0 ? Icons.brush_rounded : Icons.music_note_rounded, 
                      color: isSelected ? Colors.white : IslaColors.charcoal.withValues(alpha: 0.5), 
                      size: 18
                    ),
                    const SizedBox(width: 8),
                    Text(
                      tabs[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : IslaColors.charcoal.withValues(alpha: 0.5),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}