import 'package:flutter_animate/flutter_animate.dart';
import 'package:isla_digital/core/core.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'title': '¡Bienvenido Explorador!',
      'body': 'Isla Digital es el lugar donde aprender es la mayor aventura.',
      'lottie': 'assets/animations/ui/welcome_island.json',
      'placeholder': PlaceholderType.background,
    },
    {
      'title': 'Juega y Aprende',
      'body': 'Resuelve rompecabezas, dibuja y descubre nuevos mundos.',
      'lottie': 'assets/animations/ui/learning_books.json',
      'placeholder': PlaceholderType.icon,
    },
    {
      'title': 'Gana Medallas',
      'body': 'Colecciona insignias por cada logro y conviértete en el mejor.',
      'lottie': 'assets/animations/success/pearl.json',
      'placeholder': PlaceholderType.character,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutBack,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/profile');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [IslaColors.oceanLight, IslaColors.softWhite],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/profile'),
                  child: Text('SALTAR',
                      style: DynamicThemingEngine.labelStyle
                          .copyWith(color: IslaColors.oceanDark)),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (index) =>
                      setState(() => _currentIndex = index),
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    return Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Center(
                              child: SafeLottie(
                                path: page['lottie'] as String,
                                size: 250,
                              ).animate().scale(
                                  delay: 200.ms, curve: Curves.easeOutBack),
                            ),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            page['title'] as String,
                            style: DynamicThemingEngine.displayStyle,
                            textAlign: TextAlign.center,
                          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
                          const SizedBox(height: 16),
                          Text(
                            page['body'] as String,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: IslaColors.slate),
                            textAlign: TextAlign.center,
                          ).animate().fadeIn(delay: 600.ms),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: List.generate(_pages.length, _buildDot),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        minimumSize: const Size(64, 64),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: _nextPage,
                      child: const Icon(Icons.arrow_forward_rounded, size: 32),
                    )
                        .animate(
                            target: _currentIndex == _pages.length - 1 ? 1 : 0)
                        .scale(end: const Offset(1.1, 1.1))
                        .tint(color: IslaColors.sunflower),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

  Widget _buildDot(int index) {
    final bool isActive = _currentIndex == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 8),
      height: 12,
      width: isActive ? 32 : 12,
      decoration: BoxDecoration(
        color:
            isActive ? IslaColors.oceanBlue : IslaColors.slate.withAlpha(100),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
