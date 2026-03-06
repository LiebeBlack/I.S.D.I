import 'package:flutter_animate/flutter_animate.dart';
import 'package:isla_digital/core/core.dart';

class CitizenshipScreen extends ConsumerStatefulWidget {
  const CitizenshipScreen({super.key});

  @override
  ConsumerState<CitizenshipScreen> createState() => _CitizenshipScreenState();
}

class _CitizenshipScreenState extends ConsumerState<CitizenshipScreen> {
  int _currentProtocol = 0;

  final List<Map<String, dynamic>> _protocols = [
    {
      'title': 'EL ESCUDO DE LUZ',
      'instruction': 'Si ves algo extraño, ¡Toca el escudo y llama a un adulto!',
      'icon': Icons.security_rounded,
      'color': IslaColors.oceanBlue,
      'lottie': 'assets/animations/ui/shield.json',
    },
    {
      'title': 'CANDADO DE MAR',
      'instruction': 'Tus secretos de la isla se quedan contigo. ¡Cierra el candado!',
      'icon': Icons.lock_outline_rounded,
      'color': IslaColors.sunflower,
      'lottie': 'assets/animations/ui/lock.json',
    },
    {
      'title': 'OLA DE RESPETO',
      'instruction': 'Trata a otros exploradores con cariño, como la brisa del mar.',
      'icon': Icons.favorite_rounded,
      'color': IslaColors.sunsetPink,
      'lottie': 'assets/animations/ui/heart.json',
    },
  ];

  void _completeProtocol() {
    // Each completed protocol adds to problem solving and logic
    ref.read(currentProfileProvider.notifier).addProgress(
          'citizenship_$_currentProtocol',
          10,
          problemSolving: 5,
          logic: 3,
        );

    if (_currentProtocol < _protocols.length - 1) {
      setState(() => _currentProtocol++);
    } else {
      _showCompletion();
    }
  }

  void _showCompletion() {
    ref.read(currentProfileProvider.notifier).addBadge('guardian_isla');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¡GUARDIÁN DE LA ISLA!'),
        content: const Text('Ahora sabes cómo cuidar tu tesoro digital.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('VOLVER'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final protocol = _protocols[_currentProtocol];

    return Scaffold(
      body: IslandBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 40),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        protocol['title'] as String,
                        style: DynamicThemingEngine.displayStyle
                            .copyWith(color: IslaColors.oceanDark),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn().scale(),
                      const SizedBox(height: 40),
                      GestureDetector(
                        onTap: _completeProtocol,
                        child: GlassContainer(
                          padding: const EdgeInsets.all(32),
                          child: SafeLottie(
                            path: protocol['lottie'] as String,
                            backupIcon: protocol['icon'] as IconData,
                          ),
                        ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 2.seconds),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        protocol['instruction'] as String,
                        style: DynamicThemingEngine.subtitleStyle,
                        textAlign: TextAlign.center,
                      ).animate().fadeIn(delay: 500.ms),
                    ],
                  ),
                ),
              ),
              _buildProgress(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() => Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close_rounded, color: IslaColors.oceanDark),
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          const Text('HABILIDADES PRO',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );

  Widget _buildProgress() => Padding(
      padding: const EdgeInsets.all(32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_protocols.length, (index) => Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index <= _currentProtocol
                  ? IslaColors.oceanBlue
                  : Colors.grey.withValues(alpha: 0.3),
            ),
          )),
      ),
    );
}
