import 'package:flutter_animate/flutter_animate.dart';
import 'package:isla_digital/core/core.dart';

class SandboxScreen extends ConsumerStatefulWidget {
  const SandboxScreen({super.key});

  @override
  ConsumerState<SandboxScreen> createState() => _SandboxScreenState();
}

class _SandboxScreenState extends ConsumerState<SandboxScreen> {
  final List<Offset> _elements = [];

  void _addElement(Offset position) {
    setState(() {
      _elements.add(position);
    });
    // Sandbox play contributes to creativity
    ref.read(currentProfileProvider.notifier).addProgress(
          'sandbox',
          1,
          creativity: 2,
        );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: IslandBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: GestureDetector(
                  onTapDown: (details) => _addElement(details.localPosition),
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 2,
                      ),
                    ),
                    child: Stack(
                      children: [
                        if (_elements.isEmpty)
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.touch_app_rounded,
                                    size: 64, color: Colors.white54),
                                const SizedBox(height: 16),
                                Text(
                                  '¡Toca para crear!',
                                  style: DynamicThemingEngine.subtitleStyle.copyWith(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ..._elements.map((pos) => Positioned(
                              left: pos.dx - 40,
                              top: pos.dy - 40,
                              child: const HeroElement(),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );

  Widget _buildHeader() => Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close_rounded, color: IslaColors.oceanDark),
            onPressed: () => Navigator.pop(context),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'ÁREA DE JUEGO LIBRE',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: IslaColors.oceanDark,
            ),
          ),
        ],
      ),
    );

  Widget _buildFooter() => Padding(
      padding: const EdgeInsets.all(20),
      child: GlassContainer(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _actionIcon(Icons.brush_rounded, IslaColors.sunsetPink),
            _actionIcon(Icons.music_note_rounded, IslaColors.oceanBlue),
            _actionIcon(Icons.auto_awesome_rounded, IslaColors.sunflower),
            IconButton(
              onPressed: () => setState(_elements.clear),
              icon: const Icon(Icons.delete_sweep_rounded, color: Colors.red),
            ),
          ],
        ),
      ),
    );

  Widget _actionIcon(IconData icon, Color color) => Icon(icon, color: color, size: 32)
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .scale(
            begin: const Offset(1, 1),
            end: const Offset(1.2, 1.2),
            duration: 1.seconds);
}

class HeroElement extends StatelessWidget {
  const HeroElement({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox(
      width: 80,
      height: 80,
      child: SafeLottie(
        path: 'assets/animations/characters/parrot.json',
        backupIcon: Icons.pets_rounded,
      ),
    ).animate().scale(curve: Curves.easeOutBack).shake();
}
