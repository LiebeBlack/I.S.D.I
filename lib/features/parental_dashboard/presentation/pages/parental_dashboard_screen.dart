import 'package:flutter_animate/flutter_animate.dart';
import 'package:isla_digital/core/core.dart';

class ParentalDashboardScreen extends ConsumerStatefulWidget {
  const ParentalDashboardScreen({super.key});

  @override
  ConsumerState<ParentalDashboardScreen> createState() =>
      _ParentalDashboardScreenState();
}

class _ParentalDashboardScreenState
    extends ConsumerState<ParentalDashboardScreen> {
  bool _isAuthenticated = false;
  bool _isSettingNewPin = false;
  final _pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkInitialPinStatus();
  }

  Future<void> _checkInitialPinStatus() async {
    final hasPin = await SecureStorageService.hasCustomPin();
    if (!mounted) return;
    setState(() {
      _isSettingNewPin = !hasPin;
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _handlePinSubmit() async {
    if (_pinController.text.length < 4) {
      _showError('El PIN debe tener al menos 4 dígitos');
      return;
    }

    if (_isSettingNewPin) {
      final success = await SecureStorageService.saveParentalPin(_pinController.text);
      if (success && mounted) {
        setState(() {
          _isSettingNewPin = false;
          _isAuthenticated = true; // Auto-login after setting pin
        });
      } else {
        _showError('Error al guardar el PIN. Intenta de nuevo.');
      }
    } else {
      final isValid = await SecureStorageService.verifyParentalPin(_pinController.text);
      if (isValid && mounted) {
        setState(() => _isAuthenticated = true);
      } else {
        _pinController.clear();
        _showError('PIN incorrecto. Acceso denegado.');
      }
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TIPADO CORREGIDO: Especificamos los modelos para evitar Dynamic calls
    final ChildProfile? profile = ref.watch(currentProfileProvider);
    final ParentalSettings settings = ref.watch(parentalSettingsProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: IslandBackground(
        child: SafeArea(
          child: AnimatedSwitcher(
            duration: 400.ms,
            child: !_isAuthenticated
                ? _buildAuthLock()
                : _buildMainDashboard(profile, settings),
          ),
        ),
      ),
    );
  }

  // --- MÓDULO DE AUTENTICACIÓN ---
  Widget _buildAuthLock() => Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: GlassContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_person_rounded,
                  size: 64, color: IslaColors.oceanBlue),
              const SizedBox(height: 16),
              const Text(
                'SOLO ADULTOS',
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    color: IslaColors.oceanDark),
              ),
              const SizedBox(height: 8),
              Text(
                _isSettingNewPin 
                    ? 'Crea un PIN seguro de 4 dígitos para proteger este panel'
                    : 'Ingresa tu PIN de seguridad (Por defecto: 1234)', 
                textAlign: TextAlign.center,
                style: const TextStyle(color: IslaColors.slate),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                obscureText: true,
                maxLength: 6,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 8),
                decoration: InputDecoration(
                  hintText: '****',
                  filled: true,
                  counterText: '',
                  fillColor: Colors.white.withValues(alpha: 0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (_) => _handlePinSubmit(),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _handlePinSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: IslaColors.oceanBlue,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text(
                  'VERIFICAR',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn().scale(curve: Curves.easeOutBack);

  // --- MÓDULO DASHBOARD ---
  Widget _buildMainDashboard(ChildProfile? profile, ParentalSettings settings) => ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildHeader(),
        const SizedBox(height: 20),
        if (profile != null) _buildQuickStats(profile),
        const SizedBox(height: 20),
        _buildSectionTitle('DESARROLLO PEDAGÓGICO (CPA)'),
        if (profile != null) _buildAdvancedMetrics(profile),
        const SizedBox(height: 20),
        _buildSectionTitle('LÍMITES DE TIEMPO'),
        _buildTimeSlider(settings),
        const SizedBox(height: 20),
        _buildSectionTitle('SONIDO Y MÚSICA'),
        _buildSoundControls(settings),
        const SizedBox(height: 30),
        _buildDangerZone(),
      ],
    ).animate().slideY(begin: 0.1, end: 0);

  Widget _buildAdvancedMetrics(ChildProfile profile) => GlassContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _metricRow('Lógica', profile.logicProgress, Icons.psychology_rounded,
              IslaColors.oceanBlue),
          const SizedBox(height: 16),
          _metricRow('Creatividad', profile.creativityProgress,
              Icons.palette_rounded, IslaColors.sunsetPink),
          const SizedBox(height: 16),
          _metricRow('Resolución', profile.problemSolvingProgress,
              Icons.extension_rounded, IslaColors.jungleGreen),
        ],
      ),
    );

  Widget _metricRow(String label, int value, IconData icon, Color color) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            Text('$value%',
                style: TextStyle(color: color, fontWeight: FontWeight.w900)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: (value / 100).clamp(0.0, 1.0),
            backgroundColor: color.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 10,
          ),
        ),
      ],
    );

  Widget _buildHeader() => Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close_rounded, color: IslaColors.oceanDark),
          style: IconButton.styleFrom(
            backgroundColor: IslaColors.oceanBlue.withValues(alpha: 0.1),
          ),
        ),
        const SizedBox(width: 16),
        const Text(
          'Configuración',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
        ),
      ],
    );

  Widget _buildQuickStats(ChildProfile profile) => GlassContainer(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statColumn(
              'Nivel', profile.currentLevel.toString(), Icons.bolt_rounded),
          _statColumn('Logros', profile.earnedBadges.length.toString(),
              Icons.emoji_events_rounded),
          _statColumn('Minutos', profile.totalPlayTimeMinutes.toString(),
              Icons.history_toggle_off_rounded),
        ],
      ),
    );

  Widget _statColumn(String label, String value, IconData icon) => Column(
      children: [
        Icon(icon, color: IslaColors.oceanBlue),
        Text(value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label,
            style: const TextStyle(fontSize: 12, color: Colors.black54)),
      ],
    );

  Widget _buildTimeSlider(ParentalSettings settings) => GlassContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Límite Diario',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                '${settings.dailyTimeLimitMinutes} min',
                style: const TextStyle(
                    color: IslaColors.oceanBlue, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Slider(
            value: settings.dailyTimeLimitMinutes.toDouble(),
            min: 15, max: 120, divisions: 7,
            activeColor: IslaColors.oceanBlue,
            // CORRECCIÓN: Al usar ref.read(...) ahora el compilador sabe qué métodos existen
            onChanged: (val) => ref
                .read(parentalSettingsProvider.notifier)
                .updateTimeLimit(val.toInt()),
          ),
        ],
      ),
    );

  Widget _buildSoundControls(ParentalSettings settings) {
    final notifier = ref.read(parentalSettingsProvider.notifier);
    return GlassContainer(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Efectos Especiales'),
            secondary: const Icon(Icons.volume_up_rounded,
                color: IslaColors.oceanBlue),
            value: settings.soundEnabled,
            onChanged: (val) => notifier.toggleSound(),
          ),
          const Divider(height: 1),
          SwitchListTile(
            title: const Text('Música de Fondo'),
            secondary: const Icon(Icons.music_note_rounded,
                color: IslaColors.oceanBlue),
            value: settings.musicEnabled,
            onChanged: (val) => notifier.toggleMusic(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54),
      ),
    );

  Widget _buildDangerZone() => OutlinedButton.icon(
      onPressed: _showResetConfirmation,
      icon: const Icon(Icons.delete_sweep_rounded),
      label: const Text('BORRAR PROGRESO DEL PERFIL'),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.redAccent,
        side: const BorderSide(color: Colors.redAccent),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );

  void _showResetConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Estás seguro?'),
        content: const Text(
            'Se perderán todos los niveles completados y logros obtenidos.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCELAR')),
          TextButton(
              onPressed: () {
                // CORRECCIÓN: Llamada tipada al Reset del perfil
                ref.read(currentProfileProvider.notifier).resetProgress();
                Navigator.pop(context); // Cierra Dialog
                Navigator.pop(context); // Sale del dashboard
              },
              child: const Text('BORRAR TODO',
                  style: TextStyle(color: Colors.redAccent))),
        ],
      ),
    );
  }
}
