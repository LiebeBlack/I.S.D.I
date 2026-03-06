import 'package:isla_digital/core/core.dart';
import 'package:lottie/lottie.dart';

/// Pantalla "Galería Secreta" para previsualizar todos los recursos del proyecto.
class ShowcaseScreen extends StatefulWidget {
  const ShowcaseScreen({super.key});

  @override
  State<ShowcaseScreen> createState() => _ShowcaseScreenState();
}

class _ShowcaseScreenState extends State<ShowcaseScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isMusicActive = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    // Sincronizamos el estado inicial con el servicio de música
    _isMusicActive = BackgroundMusicService.isPlaying;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleMusicToggle() async {
    if (_isMusicActive) {
      await BackgroundMusicService.pauseMusic();
    } else {
      await BackgroundMusicService.resumeMusic();
    }
    // Actualizamos el estado basado en la realidad del servicio
    if (mounted) {
      setState(() => _isMusicActive = BackgroundMusicService.isPlaying);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text(
          'Galería Secreta 2026',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: IslaColors.oceanBlue,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: IslaColors.sunflower,
          indicatorWeight: 4,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withValues(alpha: 0.5),
          tabs: const [
            Tab(icon: Icon(Icons.animation), text: 'Lottie'),
            Tab(icon: Icon(Icons.music_note), text: 'Audio'),
            Tab(icon: Icon(Icons.image), text: 'Fondos'),
            Tab(icon: Icon(Icons.apps), text: 'Iconos'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAnimationsTab(),
          _buildAudioTab(),
          _buildBackgroundsTab(),
          _buildIconsTab(),
        ],
      ),
    );

  Widget _buildAnimationsTab() => SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Interfaz (UI)'),
          const SizedBox(height: 12),
          _animationCard(
              'Carga de Ola', 'assets/animations/ui/wave_loading.json'),
          _animationCard(
              'Sol de Bienvenida', 'assets/animations/ui/welcome_sun.json'),
          const SizedBox(height: 24),
          _sectionTitle('Personajes'),
          const SizedBox(height: 12),
          _animationCard('Jirafa Meditando',
              'assets/animations/characters/meditating_giraffe.json'),
          _animationCard('Gato Caminando',
              'assets/animations/characters/cat_movement.json'),
        ],
      ),
    );

  Widget _animationCard(String name, String path) => Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Lottie.asset(
              path,
              height: 150,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const SizedBox(
                height: 150,
                child: Center(
                  child: Icon(Icons.broken_image_rounded,
                      color: IslaColors.coralReef, size: 50),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(path,
                style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );

  Widget _buildAudioTab() => Container(
      width: double.infinity,
      color: IslaColors.oceanBlue.withValues(alpha: 0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: _isMusicActive ? IslaColors.sunflower : Colors.grey[300],
              shape: BoxShape.circle,
              boxShadow: _isMusicActive
                  ? [
                      BoxShadow(
                        color: IslaColors.sunflower.withValues(alpha: 0.4),
                        blurRadius: 20,
                        spreadRadius: 5,
                      )
                    ]
                  : [],
            ),
            child: Icon(
              _isMusicActive
                  ? Icons.music_note_rounded
                  : Icons.music_off_rounded,
              size: 80,
              color: _isMusicActive ? IslaColors.oceanDark : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          Text(
            _isMusicActive ? 'Música Sonando' : 'Música en Pausa',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: _handleMusicToggle,
            style: ElevatedButton.styleFrom(
              backgroundColor: IslaColors.oceanBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            icon: Icon(_isMusicActive
                ? Icons.pause_rounded
                : Icons.play_arrow_rounded),
            label: Text(_isMusicActive ? 'DETENER MÚSICA' : 'PROBAR MÚSICA'),
          ),
        ],
      ),
    );

  Widget _buildBackgroundsTab() {
    final bgs = [
      {
        't': 'Playa Tropical',
        'p': 'assets/images/backgrounds/bg_beach_tropical_day.jpg'
      },
      {
        't': 'Menú (Blur)',
        'p': 'assets/images/backgrounds/bg_main_menu_blurred.png'
      },
      {
        't': 'Noche Estrellada',
        'p': 'assets/images/backgrounds/bg_sky_night_stars.webp'
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bgs.length,
      itemBuilder: (context, i) => Card(
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            Image.asset(
              bgs[i]['p']!,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 200,
                color: Colors.grey[200],
                child: const Icon(Icons.image_not_supported_rounded, size: 50),
              ),
            ),
            ListTile(
              title: Text(bgs[i]['t']!,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle:
                  Text(bgs[i]['p']!, style: const TextStyle(fontSize: 10)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildIconsTab() {
    final icons = ['app_icon', 'splash_logo', 'app_icon_foreground'];
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: icons.length,
      itemBuilder: (context, i) => DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Image.asset(
                  'assets/icons/${icons[i]}.png',
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.help_outline_rounded, size: 40),
                ),
              ),
            ),
            Text(icons[i],
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: IslaColors.oceanDark),
      ),
    );
}
