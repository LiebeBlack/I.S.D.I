import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isla_digital/core/theme/app_theme.dart';
import 'package:isla_digital/domain/models/badge.dart';
import 'package:isla_digital/domain/models/child_profile.dart';
import 'package:isla_digital/domain/models/parental_settings.dart';
import 'package:isla_digital/presentation/providers/app_providers.dart';
import 'package:isla_digital/presentation/widgets/badge_card.dart';
import 'package:isla_digital/presentation/widgets/glass_container.dart';
import 'package:isla_digital/presentation/widgets/island_background.dart';

/// Dashboard de Control Parental con bloqueo matemático estándar 2026
class ParentalDashboardScreen extends ConsumerStatefulWidget {
  const ParentalDashboardScreen({super.key});

  @override
  ConsumerState<ParentalDashboardScreen> createState() =>
      _ParentalDashboardScreenState();
}

class _ParentalDashboardScreenState
    extends ConsumerState<ParentalDashboardScreen> {
  bool _isAuthenticated = false;
  int _num1 = 0;
  int _num2 = 0;
  String _operation = '';
  final _answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _generateMathProblem();
  }

  /// Genera un reto matemático simple pero efectivo para evitar acceso accidental de niños
  void _generateMathProblem() {
    final random = Random();
    _num1 = random.nextInt(10) + 1;
    _num2 = random.nextInt(10) + 1;

    final operations = ['+', '-'];
    _operation = operations[random.nextInt(operations.length)];

    // Asegurar que el resultado no sea negativo para facilitar a los padres
    if (_operation == '-' && _num1 < _num2) {
      final temp = _num1;
      _num1 = _num2;
      _num2 = temp;
    }
  }

  int _getCorrectAnswer() {
    switch (_operation) {
      case '+': return _num1 + _num2;
      case '-': return _num1 - _num2;
      default: return 0;
    }
  }

  void _checkAnswer() {
    final answer = int.tryParse(_answerController.text);
    if (answer == _getCorrectAnswer()) {
      setState(() => _isAuthenticated = true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Respuesta incorrecta. Intenta de nuevo.'),
          backgroundColor: IslaColors.coralReef,
          behavior: SnackBarBehavior.floating,
        ),
      );
      _answerController.clear();
      _generateMathProblem();
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(currentProfileProvider);
    final settings = ref.watch(parentalSettingsProvider);
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width <= 360;

    return Scaffold(
      // Evita que el teclado rompa el fondo de la isla
      resizeToAvoidBottomInset: true,
      body: IslandBackground(
        child: SafeArea(
          child: !_isAuthenticated
              ? _buildAuthScreen(isSmallScreen)
              : _buildDashboard(profile, settings, isSmallScreen),
        ),
      ),
    );
  }

  /// Pantalla de Bloqueo (Puerta de entrada para padres)
  Widget _buildAuthScreen(bool isSmallScreen) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/app_icon.png',
              height: isSmallScreen ? 80 : 100,
            ),
            const SizedBox(height: 24),
            Text(
              'Acceso para Padres',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: IslaColors.oceanDark,
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: 32),
            GlassContainer(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    'Resuelve para entrar:',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: IslaColors.oceanDark,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '$_num1 $_operation $_num2 = ?',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: IslaColors.oceanBlue,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _answerController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    autofocus: true,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: IslaColors.oceanDark,
                    ),
                    decoration: InputDecoration(
                      hintText: '?',
                      filled: true,
                      // ESTÁNDAR 2026: withValues para transparencia
                      fillColor: Colors.white.withValues(alpha: 0.5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => _checkAnswer(),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _checkAnswer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: IslaColors.oceanBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'VERIFICAR',
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'VOLVER A LA ISLA',
                style: TextStyle(
                  color: IslaColors.oceanDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Dashboard Principal (Visible solo tras autenticación)
  Widget _buildDashboard(ChildProfile? profile, ParentalSettings settings, bool isSmallScreen) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDashboardHeader(),
          const SizedBox(height: 24),
          _buildChildStats(profile),
          const SizedBox(height: 16),
          _buildTimeLimitCard(settings),
          const SizedBox(height: 16),
          _buildSoundSettingsCard(settings),
          const SizedBox(height: 16),
          _buildBadgesCard(profile, isSmallScreen),
          const SizedBox(height: 32),
          _buildExitButton(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildDashboardHeader() {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: 20,
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: IslaColors.oceanBlue,
            child: Icon(Icons.settings, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Panel de Control',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: IslaColors.oceanDark),
                ),
                Text(
                  'Configura la experiencia de tu explorador',
                  style: TextStyle(fontSize: 12, color: IslaColors.oceanDark.withValues(alpha: 0.7)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildStats(ChildProfile? profile) {
    if (profile == null) return const SizedBox.shrink();

    return GlassContainer(
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Progreso de ${profile.name}',
            style: const TextStyle(fontWeight: FontWeight.w900, color: IslaColors.oceanDark),
          ),
          const SizedBox(height: 16),
          _buildStatRow(Icons.timer, 'Tiempo jugado', '${profile.totalPlayTimeMinutes} min'),
          _buildStatRow(Icons.emoji_events, 'Insignias', '${profile.earnedBadges.length}'),
          _buildStatRow(Icons.star, 'Nivel', '${profile.currentLevel}'),
        ],
      ),
    );
  }

  Widget _buildStatRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: IslaColors.oceanBlue),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: IslaColors.oceanDark)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: IslaColors.oceanBlue)),
        ],
      ),
    );
  }

  Widget _buildTimeLimitCard(ParentalSettings settings) {
    return GlassContainer(
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Límite de Tiempo Diario', style: TextStyle(fontWeight: FontWeight.bold)),
          Slider(
            value: settings.dailyTimeLimitMinutes.toDouble(),
            min: 15,
            max: 120,
            divisions: 7,
            activeColor: IslaColors.oceanBlue,
            label: '${settings.dailyTimeLimitMinutes} min',
            onChanged: (v) => ref.read(parentalSettingsProvider.notifier).updateTimeLimit(v.toInt()),
          ),
          Center(child: Text('${settings.dailyTimeLimitMinutes} minutos diarios')),
        ],
      ),
    );
  }

  Widget _buildSoundSettingsCard(ParentalSettings settings) {
    return GlassContainer(
      borderRadius: 20,
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Efectos de Sonido'),
            value: settings.soundEnabled,
            activeThumbColor: IslaColors.oceanBlue,
            onChanged: (_) => ref.read(parentalSettingsProvider.notifier).toggleSound(),
          ),
          SwitchListTile(
            title: const Text('Música de Fondo'),
            value: settings.musicEnabled,
            activeThumbColor: IslaColors.oceanBlue,
            onChanged: (_) => ref.read(parentalSettingsProvider.notifier).toggleMusic(),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgesCard(ChildProfile? profile, bool isSmallScreen) {
    final earnedIds = profile?.earnedBadges ?? [];
    return GlassContainer(
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Logros del Explorador', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: IslaBadges.allBadges.map((badge) {
              return BadgeCard(
                badge: badge,
                isEarned: earnedIds.contains(badge.id),
                size: isSmallScreen ? 40 : 50,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildExitButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => Navigator.pop(context),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: IslaColors.oceanBlue, width: 2),
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: const Text('SALIR DEL PANEL', style: TextStyle(fontWeight: FontWeight.w900)),
      ),
    );
  }
}