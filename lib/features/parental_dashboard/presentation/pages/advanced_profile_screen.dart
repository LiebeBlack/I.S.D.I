import 'package:isla_digital/core/core.dart';

class AdvancedProfileScreen extends ConsumerWidget {
  const AdvancedProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileProvider);
    final theme = Theme.of(context);

    if (profile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final totalPoints = profile.levelProgress.values.fold(0, (a, b) => a + b);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title:
            Text('Perfil del Explorador', style: DynamicThemingEngine.titleMediumStyle),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: IslaColors.charcoal),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          color: IslaColors.softWhite,
          image: DecorationImage(
            image: AssetImage(
                'assets/images/backgrounds/pattern.png'), // Will fail gracefully to flat color if missing
            opacity: 0.05,
            repeat: ImageRepeat.repeat,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(24),
            physics: const BouncingScrollPhysics(),
            children: [
              _buildHeader(profile.name, profile.age, theme),
              const SizedBox(height: 32),
              _buildStatsGrid(totalPoints, profile.earnedBadges.length,
                  profile.currentLevel),
              const SizedBox(height: 32),
              _buildProgressSection(profile.levelProgress, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String name, int age, ThemeData theme) => Center(
      child: Column(
        children: [
          const Hero(
            tag: 'profile_avatar_big',
            child: AssetPlaceholderFallback(width: 120, height: 120),
          ),
          const SizedBox(height: 16),
          Text(name.toUpperCase(), style: DynamicThemingEngine.displayStyle),
          Text('$age AÑOS', style: DynamicThemingEngine.labelStyle),
        ],
      ),
    );

  Widget _buildStatsGrid(int points, int badges, int levels) => Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _StatCard(
            title: 'Puntos',
            value: '$points',
            icon: Icons.star_rounded,
            color: IslaColors.sunflower),
        _StatCard(
            title: 'Medallas',
            value: '$badges',
            icon: Icons.emoji_events_rounded,
            color: IslaColors.jungleGreen),
        _StatCard(
            title: 'Nivel',
            value: '$levels',
            icon: Icons.landscape_rounded,
            color: IslaColors.oceanBlue),
      ],
    );

  Widget _buildProgressSection(Map<String, int> progress, ThemeData theme) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Progreso por Módulos', style: DynamicThemingEngine.titleMediumStyle),
        const SizedBox(height: 16),
        ...progress.entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GlassContainer(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Módulo ${e.key}',
                            style: theme.textTheme.bodyLarge),
                        Text('${e.value} pts',
                            style: DynamicThemingEngine.labelStyle
                                .copyWith(color: IslaColors.oceanBlue)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: (e.value / 1000).clamp(0.0, 1.0),
                      backgroundColor: IslaColors.mist,
                      color: IslaColors.oceanBlue,
                      borderRadius: BorderRadius.circular(4),
                      minHeight: 8,
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
}

class _StatCard extends StatelessWidget {
  const _StatCard(
      {required this.title,
      required this.value,
      required this.icon,
      required this.color});
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(value, style: DynamicThemingEngine.displayStyle.copyWith(fontSize: 24)),
          Text(title, style: DynamicThemingEngine.labelStyle.copyWith(fontSize: 12)),
        ],
      ),
    );
}
