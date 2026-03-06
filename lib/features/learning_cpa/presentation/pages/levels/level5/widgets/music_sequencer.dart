import 'package:isla_digital/core/core.dart';

class MusicSequencer extends StatelessWidget {
  const MusicSequencer({super.key, required this.onProgress});
  final VoidCallback onProgress;

  @override
  Widget build(BuildContext context) => GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: 9,
      itemBuilder: (context, index) => GestureDetector(
          onTap: onProgress,
          child: DecoratedBox(
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
            child: const Icon(Icons.music_note_rounded,
                color: Colors.white, size: 40),
          ),
        ),
    );
}
