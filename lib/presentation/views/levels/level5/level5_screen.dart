import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isla_digital/core/theme/app_theme.dart';
import 'package:isla_digital/domain/models/badge.dart';
import 'package:isla_digital/presentation/providers/app_providers.dart';
import 'package:isla_digital/presentation/widgets/glass_container.dart';
import 'package:isla_digital/presentation/widgets/island_background.dart';
import 'package:isla_digital/presentation/widgets/progress_widgets.dart';
import 'package:isla_digital/presentation/widgets/safe_lottie.dart';

class Level5Screen extends ConsumerStatefulWidget {
  const Level5Screen({super.key});

  @override
  ConsumerState<Level5Screen> createState() => _Level5ScreenState();
}

class _Level5ScreenState extends ConsumerState<Level5Screen> {
  int currentTab = 0;
  int totalProgress = 0;
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

  void _addProgress(int points) {
    setState(() {
      totalProgress += points;
      if (totalProgress >= 100) {
        _completeLevel();
      }
    });
    ref.read(currentProfileProvider.notifier).addProgress('level_5', points);
  }

  void _completeLevel() {
    _confettiController.play();
    final badge = IslaBadges.getById('artista_isla');
    if (badge != null) {
      ref.read(currentProfileProvider.notifier).addBadge(badge.id);
    }
    final musicianBadge = IslaBadges.getById('musician_tropical');
    if (musicianBadge != null) {
      ref.read(currentProfileProvider.notifier).addBadge(musicianBadge.id);
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white.withValues(alpha: 0.95),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        title: const Text('¡GRAN ARTISTA!', textAlign: TextAlign.center),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SafeLottie(
              path: 'assets/animations/success/artist.json',
              backupIcon: Icons.palette_rounded,
            ),
            SizedBox(height: 16),
            Text('¡Tus creaciones son maravillosas!'),
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
                        DrawingCanvas(onProgress: _addProgress),
                        MusicSequencer(onProgress: _addProgress),
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
            'ARTISTA',
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
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(index == 0 ? Icons.brush_rounded : Icons.music_note_rounded, color: isSelected ? Colors.white : IslaColors.charcoal.withValues(alpha: 0.5), size: 18),
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

class DrawingCanvas extends StatefulWidget {
  const DrawingCanvas({super.key, required this.onProgress});
  final Function(int) onProgress;

  @override
  State<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  List<DrawPoint?> points = [];
  Color selectedColor = IslaColors.oceanBlue;
  double strokeWidth = 8;
  int strokes = 0;

  final List<Color> palette = [
    IslaColors.oceanBlue, IslaColors.sunflower, IslaColors.jungleGreen,
    IslaColors.sunsetPink, IslaColors.charcoal, Colors.white,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: GlassContainer(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: palette.map((c) => GestureDetector(
                onTap: () => setState(() => selectedColor = c),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: c,
                    shape: BoxShape.circle,
                    border: Border.all(color: selectedColor == c ? Colors.white : Colors.transparent, width: 3),
                    boxShadow: [if(selectedColor == c) BoxShadow(color: c.withValues(alpha: 0.4), blurRadius: 8)],
                  ),
                ),
              )).toList(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20)],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: GestureDetector(
                onPanUpdate: (d) {
                  setState(() {
                    points.add(DrawPoint(offset: d.localPosition, paint: Paint()
                      ..color = selectedColor
                      ..strokeWidth = strokeWidth
                      ..strokeCap = StrokeCap.round));
                  });
                },
                onPanEnd: (_) {
                  points.add(null);
                  strokes++;
                  if (strokes == 10) widget.onProgress(20);
                },
                child: CustomPaint(
                  painter: DrawingPainter(points: points),
                  size: Size.infinite,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Expanded(
                child: Slider(
                  value: strokeWidth,
                  min: 4, max: 30,
                  activeColor: selectedColor,
                  onChanged: (v) => setState(() => strokeWidth = v),
                ),
              ),
              const SizedBox(width: 16),
              IconButton.filled(
                icon: const Icon(Icons.delete_rounded),
                onPressed: () => setState(() => points.clear()),
                style: IconButton.styleFrom(backgroundColor: IslaColors.coralReef),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DrawPoint {
  DrawPoint({required this.offset, required this.paint});
  final Offset offset;
  final Paint paint;
}

class DrawingPainter extends CustomPainter {
  DrawingPainter({required this.points});
  final List<DrawPoint?> points;

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i+1] != null) {
        canvas.drawLine(points[i]!.offset, points[i+1]!.offset, points[i]!.paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter old) => true;
}

class MusicSequencer extends StatefulWidget {
  const MusicSequencer({super.key, required this.onProgress});
  final Function(int) onProgress;

  @override
  State<MusicSequencer> createState() => _MusicSequencerState();
}

class _MusicSequencerState extends State<MusicSequencer> {
  final int beats = 8;
  final List<List<bool>> grid = List.generate(4, (_) => List.generate(8, (_) => false));
  int currentBeat = -1;
  bool isPlaying = false;

  final List<IconData> icons = [Icons.notifications_rounded, Icons.grain_rounded, Icons.star_rounded, Icons.waves_rounded];
  final List<Color> colors = [IslaColors.sunflower, IslaColors.jungleGreen, IslaColors.sunsetPink, IslaColors.oceanBlue];

  void _play() async {
    if (isPlaying) return;
    setState(() => isPlaying = true);
    for (int i = 0; i < beats; i++) {
      if (!mounted) return;
      setState(() => currentBeat = i);
      await Future.delayed(const Duration(milliseconds: 300));
    }
    setState(() {
      isPlaying = false;
      currentBeat = -1;
    });
    widget.onProgress(20);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Expanded(
            child: GlassContainer(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: List.generate(4, (r) => Expanded(
                  child: Row(
                    children: List.generate(8, (c) => Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => grid[r][c] = !grid[r][c]),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: grid[r][c] ? colors[r] : Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: currentBeat == c ? Colors.white : Colors.transparent, width: 2),
                          ),
                          child: Icon(icons[r], size: 16, color: grid[r][c] ? Colors.white : colors[r].withValues(alpha: 0.3)),
                        ),
                      ),
                    )),
                  ),
                )),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _play,
            icon: Icon(isPlaying ? Icons.stop_rounded : Icons.play_arrow_rounded),
            label: Text(isPlaying ? 'REPRODUCIENDO...' : '¡TOCAR MI MÚSICA!'),
            style: ElevatedButton.styleFrom(
              backgroundColor: IslaColors.jungleGreen,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            ),
          ),
        ],
      ),
    );
  }
}
