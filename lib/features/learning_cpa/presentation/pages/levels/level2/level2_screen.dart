import 'package:confetti/confetti.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:isla_digital/core/core.dart';

class Level2Screen extends ConsumerStatefulWidget {
  const Level2Screen({super.key});

  @override
  ConsumerState<Level2Screen> createState() => _Level2ScreenState();
}

class _Level2ScreenState extends ConsumerState<Level2Screen> {
  int currentStep = 0;
  int totalProgress = 0;
  bool _isLevelCompleted = false;
  late ConfettiController _confettiController;
  final PageController _pageController = PageController();

  final List<Map<String, dynamic>> steps = [
    {
      'title': 'Chat Seguro',
      'instruction': '¿Con quién es seguro hablar?',
      'type': 'safe_chat',
      'icon': Icons.chat_bubble_rounded,
      'color': IslaColors.oceanBlue,
    },
    {
      'title': 'Llamada de Héroe',
      'instruction': '¿Cuándo pedimos ayuda?',
      'type': 'emergency_call',
      'icon': Icons.phone_rounded,
      'color': IslaColors.coralReef,
    },
    {
      'title': 'Tus Fotos',
      'instruction': '¿Qué es seguro compartir?',
      'type': 'photo_share',
      'icon': Icons.photo_library_rounded,
      'color': IslaColors.sunflower,
    },
  ];

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _completeStep(int points) {
    setState(() {
      totalProgress += points;
      if (currentStep < steps.length - 1) {
        currentStep++;
        _pageController.nextPage(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutBack,
        );
      } else {
        _completeLevel();
      }
    });

    // Guardar progreso en el estado global
    ref.read(currentProfileProvider.notifier).addProgress('level_2', points);
  }

  void _completeLevel() {
    if (_isLevelCompleted) return;
    _isLevelCompleted = true;

    _confettiController.play();

    // FIX: Uso correcto del sistema de insignias definido en el Paso 4
    final notifier = ref.read(currentProfileProvider.notifier);
    notifier.addBadge('comunicador_seguro');
    notifier.unlockLevel(3);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white.withValues(alpha: 0.95),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        title: Text(
          '¡COMUNICADOR MAESTRO!',
          textAlign: TextAlign.center,
          style:
              DynamicThemingEngine.titleMediumStyle.copyWith(color: IslaColors.oceanDark),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SafeLottie(
              path: 'assets/animations/success/trophy.json',
            ),
            SizedBox(height: 16),
            Text('¡Ganaste la Medalla de Conexión!',
                textAlign: TextAlign.center),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar diálogo
                Navigator.pop(context); // Volver al mapa
              },
              child: const Text('VOLVER AL MAPA'),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
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
                  const SizedBox(height: 24),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: steps.length,
                      itemBuilder: (context, index) =>
                          _buildStepContent(steps[index]),
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

  Widget _buildHeader() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close_rounded,
                color: IslaColors.oceanDark, size: 32),
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          Text(
            'CONECTADOS',
            style: DynamicThemingEngine.titleMediumStyle
                .copyWith(color: IslaColors.oceanDark),
          ),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );

  Widget _buildStepContent(Map<String, dynamic> step) {
    final type = step['type'] as String;
    switch (type) {
      case 'safe_chat':
        return _buildSafeChatStep(step);
      case 'emergency_call':
        return _buildEmergencyCallStep(step);
      case 'photo_share':
        return _buildPhotoShareStep(step);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildSafeChatStep(Map<String, dynamic> step) {
    final List<Map<String, dynamic>> contacts = [
      {
        'name': 'Mamá',
        'icon': Icons.face_3_rounded,
        'safe': true,
        'color': IslaColors.sunsetPink
      },
      {
        'name': 'Papá',
        'icon': Icons.face_rounded,
        'safe': true,
        'color': IslaColors.oceanBlue
      },
      {
        'name': 'Abuelo',
        'icon': Icons.face_6_rounded,
        'safe': true,
        'color': IslaColors.jungleGreen
      },
      {
        'name': 'Desconocido',
        'icon': Icons.help_outline_rounded,
        'safe': false,
        'color': IslaColors.slate
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            step['instruction'] as String,
            style: DynamicThemingEngine.subtitleStyle,
            textAlign: TextAlign.center,
          ).animate().fadeIn(),
          const SizedBox(height: 32),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return _buildContactCard(
                  contact['name']! as String,
                  contact['icon']! as IconData,
                  contact['safe']! as bool,
                  contact['color']! as Color,
                )
                    .animate()
                    .scale(delay: (index * 100).ms, curve: Curves.easeOutBack);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(String name, IconData icon, bool safe, Color color) => GestureDetector(
      onTap: () {
        if (safe) {
          _completeStep(33);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('¡Cuidado! No hablamos con extraños.'),
              backgroundColor: IslaColors.coralReef,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
          );
        }
      },
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 12),
            Text(
              name,
              style: DynamicThemingEngine.labelStyle.copyWith(color: IslaColors.charcoal),
            ),
          ],
        ),
      ),
    );

  Widget _buildEmergencyCallStep(Map<String, dynamic> step) {
    final List<Map<String, dynamic>> emergencies = [
      {
        'icon': Icons.local_hospital_rounded,
        'label': 'Médico',
        'color': IslaColors.coralReef
      },
      {
        'icon': Icons.local_police_rounded,
        'label': 'Policía',
        'color': IslaColors.oceanBlue
      },
      {
        'icon': Icons.fire_truck_rounded,
        'label': 'BOMBEROS',
        'color': IslaColors.tropicOrange
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            step['instruction'] as String,
            style: DynamicThemingEngine.subtitleStyle,
          ).animate().fadeIn(),
          const SizedBox(height: 32),
          Expanded(
            child: ListView.separated(
              itemCount: emergencies.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final e = emergencies[index];
                return BigButton(
                  icon: e['icon']! as IconData,
                  label: e['label']! as String,
                  color: e['color']! as Color,
                  onPressed: () => _showEmergencyDialog(e['label']! as String),
                ).animate().slideX(begin: 0.2, delay: (index * 100).ms);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showEmergencyDialog(String service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text('¿Llamar a $service?',
            style: const TextStyle(fontWeight: FontWeight.w900)),
        content: const Text(
            'Solo llamamos en emergencias reales. ¡Muy bien por saber a quién acudir!'),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _completeStep(33);
              },
              child: const Text('¡ENTENDIDO!'),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPhotoShareStep(Map<String, dynamic> step) {
    final List<Map<String, dynamic>> photos = [
      {'label': 'Mi Perrito', 'icon': Icons.pets_rounded, 'safe': true},
      {'label': 'Mi Avión', 'icon': Icons.toys_rounded, 'safe': true},
      {'label': 'Mi Dirección', 'icon': Icons.house_rounded, 'safe': false},
    ];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            step['instruction'] as String,
            style: DynamicThemingEngine.subtitleStyle,
          ).animate().fadeIn(),
          const SizedBox(height: 32),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: photos.length,
              itemBuilder: (context, index) {
                final photo = photos[index];
                return _buildContactCard(
                  photo['label']! as String,
                  photo['icon']! as IconData,
                  photo['safe']! as bool,
                  (photo['safe']! as bool)
                      ? IslaColors.jungleGreen
                      : IslaColors.charcoal,
                ).animate().fadeIn(delay: (index * 100).ms);
              },
            ),
          ),
        ],
      ),
    );
  }
}
