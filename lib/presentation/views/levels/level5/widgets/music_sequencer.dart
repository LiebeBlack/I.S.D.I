import 'package:flutter/material.dart';
import 'package:isla_digital/core/theme/app_theme.dart';

class MusicSequencer extends StatelessWidget {
  final VoidCallback onProgress;
  const MusicSequencer({super.key, required this.onProgress});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // Aquí llamarías a un servicio de sonido
            onProgress();
          },
          child: Container(
            decoration: BoxDecoration(
              color: IslaColors.oceanBlue.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: const Icon(Icons.music_note_rounded, color: Colors.white, size: 40),
          ),
        );
      },
    );
  }
}