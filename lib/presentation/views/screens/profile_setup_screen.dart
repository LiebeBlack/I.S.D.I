import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isla_digital/core/theme/app_theme.dart';
import 'package:isla_digital/presentation/providers/app_providers.dart';
import 'package:isla_digital/presentation/widgets/big_button.dart';
import 'package:isla_digital/presentation/widgets/glass_container.dart';
import 'package:isla_digital/presentation/widgets/island_background.dart';
import 'package:isla_digital/presentation/widgets/safe_lottie.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _nameController = TextEditingController();
  int _selectedAge = 5;
  int _selectedAvatar = 0;
  bool _isSaving = false;

  final List<IconData> _avatars = [
    Icons.face_retouching_natural_rounded,
    Icons.face_5_rounded,
    Icons.face_6_rounded,
    Icons.face_4_rounded,
    Icons.face_2_rounded,
    Icons.face_3_rounded,
  ];

  final List<Color> _avatarColors = [
    IslaColors.oceanBlue,
    IslaColors.jungleGreen,
    IslaColors.sunsetPink,
    IslaColors.sunflower,
    IslaColors.royalPurple,
    IslaColors.coralReef,
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡QUEREMOS SABER TU NOMBRE!'), 
          backgroundColor: IslaColors.coralReef
        ),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      // CORRECCIÓN: Llamada segura al notifier sin casteo dinámico innecesario
      // Se asume que currentProfileProvider.notifier es el ProfileNotifier
      await ref.read(currentProfileProvider.notifier).createProfile(
            name,
            _selectedAge,
            avatar: _selectedAvatar.toString(),
          );
          
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al crear perfil. Intenta de nuevo.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Evita que el teclado rompa el diseño
      resizeToAvoidBottomInset: true,
      body: IslandBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                _buildAvatarGrid(),
                const SizedBox(height: 32),
                _buildFormSection(),
                const SizedBox(height: 48),
                if (_isSaving)
                  const CircularProgressIndicator(color: IslaColors.jungleGreen)
                else
                  BigButton(
                    icon: Icons.check_circle_rounded,
                    label: '¡A EXPLORAR!',
                    color: IslaColors.jungleGreen,
                    onPressed: _saveProfile,
                  ).animate().scale(delay: 500.ms, curve: Curves.easeOutBack),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const SafeLottie(
          path: 'assets/animations/ui/welcome_sun.json',
          backupIcon: Icons.wb_sunny_rounded,
          size: 120,
        ),
        const SizedBox(height: 16),
        Text(
          'NUEVO EXPLORADOR',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: IslaColors.oceanDark,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
        Text(
          '¡CREA TU PERFIL MÁGICO!',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: IslaColors.oceanDark.withValues(alpha: 0.5),
          ),
        ),
      ],
    ).animate().fadeIn().slideY(begin: -0.2, end: 0);
  }

  Widget _buildAvatarGrid() {
    return GlassContainer(
      child: Column(
        children: [
          const Text(
            'ELIGE TU AVATAR', 
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: IslaColors.oceanDark)
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: List.generate(_avatars.length, (index) {
              final isSelected = _selectedAvatar == index;
              return GestureDetector(
                onTap: () => setState(() => _selectedAvatar = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? _avatarColors[index] : Colors.white.withValues(alpha: 0.5), 
                      width: 3
                    ),
                  ),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: _avatarColors[index],
                      shape: BoxShape.circle,
                      boxShadow: isSelected 
                        ? [BoxShadow(color: _avatarColors[index].withValues(alpha: 0.4), blurRadius: 10)] 
                        : [],
                    ),
                    child: Icon(_avatars[index], color: Colors.white, size: 32),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).scale(curve: Curves.easeOutQuad);
  }

  Widget _buildFormSection() {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '¿CÓMO TE LLAMAS?', 
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: IslaColors.oceanDark)
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            maxLength: 12,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: IslaColors.oceanDark),
            decoration: InputDecoration(
              hintText: 'ESCRIBE AQUÍ...',
              counterText: '',
              prefixIcon: const Icon(Icons.star_rounded, color: IslaColors.sunflower),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20), 
                borderSide: BorderSide.none
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            '¿CUÁNTOS AÑOS TIENES?', 
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: IslaColors.oceanDark)
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [4, 5, 6, 7].map((age) {
              final isSelected = _selectedAge == age;
              return GestureDetector(
                onTap: () => setState(() => _selectedAge = age),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isSelected ? IslaColors.oceanBlue : Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.1), 
                      width: 2
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '$age',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: isSelected ? Colors.white : IslaColors.charcoal.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0);
  }
}