import 'package:isla_digital/core/core.dart';
import 'package:isla_digital/core/services/notification_service.dart';

class AdvancedSettingsScreen extends ConsumerStatefulWidget {
  const AdvancedSettingsScreen({super.key});

  @override
  ConsumerState<AdvancedSettingsScreen> createState() =>
      _AdvancedSettingsScreenState();
}

class _AdvancedSettingsScreenState
    extends ConsumerState<AdvancedSettingsScreen> {
  final NotificationService _notificationService = NotificationService();
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(parentalSettingsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title:
            Text('Configuración Avanzada', style: DynamicThemingEngine.titleMediumStyle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: IslaColors.charcoal),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [IslaColors.mist, IslaColors.softWhite],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            children: [
              _buildSectionTitle('Audiovisual'),
              GlassContainer(
                child: Column(
                  children: [
                    SwitchListTile(
                      activeTrackColor:
                          IslaColors.jungleGreen.withValues(alpha: 0.5),
                      activeThumbColor: IslaColors.jungleGreen,
                      title: Text('Música de Fondo',
                          style: theme.textTheme.bodyLarge),
                      subtitle: const Text('Banda sonora en la isla'),
                      value: settings.musicEnabled,
                      onChanged: (val) => ref
                          .read(parentalSettingsProvider.notifier)
                          .toggleMusic(),
                      secondary: const Icon(Icons.music_note_rounded,
                          color: IslaColors.oceanBlue),
                    ),
                    const Divider(height: 1, indent: 60),
                    SwitchListTile(
                      activeTrackColor:
                          IslaColors.jungleGreen.withValues(alpha: 0.5),
                      activeThumbColor: IslaColors.jungleGreen,
                      title: Text('Efectos de Sonido',
                          style: theme.textTheme.bodyLarge),
                      subtitle: const Text('Retroalimentación de botones'),
                      value: settings.soundEnabled,
                      onChanged: (val) => ref
                          .read(parentalSettingsProvider.notifier)
                          .toggleSound(),
                      secondary: const Icon(Icons.volume_up_rounded,
                          color: IslaColors.oceanBlue),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _buildSectionTitle('Límites y Hábitos'),
              GlassContainer(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.timer_rounded,
                          color: IslaColors.sunsetPink),
                      title: Text('Tiempo de pantalla',
                          style: theme.textTheme.bodyLarge),
                      subtitle: Text(
                          '${settings.dailyTimeLimitMinutes} minutos diarios'),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit_rounded),
                        onPressed: () => _editTimeLimit(
                            context, settings.dailyTimeLimitMinutes),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _buildSectionTitle('Notificaciones (Mock)'),
              GlassContainer(
                child: Column(
                  children: [
                    SwitchListTile(
                      activeTrackColor:
                          IslaColors.royalPurple.withValues(alpha: 0.5),
                      activeThumbColor: IslaColors.royalPurple,
                      title: Text('Recordatorios de Estudio',
                          style: theme.textTheme.bodyLarge),
                      subtitle: const Text(
                          'Avisar cuando es hora de jugar y aprender'),
                      value: _notificationsEnabled,
                      onChanged: (val) {
                        setState(() => _notificationsEnabled = val);
                        if (val) {
                          _notificationService.scheduleReminder(
                              title: '¡Hora de volver a la Isla!',
                              body: 'Tus amigos animales te extrañan.',
                              delay: const Duration(minutes: 5));
                        } else {
                          _notificationService.cancelAll();
                        }
                      },
                      secondary: const Icon(Icons.notifications_active_rounded,
                          color: IslaColors.coralReef),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: DynamicThemingEngine.labelStyle,
      ),
    );

  void _editTimeLimit(BuildContext context, int currentLimit) {
    showDialog(
      context: context,
      builder: (context) {
        double tempLimit = currentLimit.toDouble();
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
              title: Text('Límite Diario', style: DynamicThemingEngine.titleMediumStyle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${tempLimit.toInt()} Minutos',
                      style: DynamicThemingEngine.displayStyle),
                  Slider(
                    value: tempLimit,
                    min: 10,
                    max: 120,
                    divisions: 11,
                    onChanged: (val) => setState(() => tempLimit = val),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('CANCELAR'),
                ),
                ElevatedButton(
                  onPressed: () {
                    ref
                        .read(parentalSettingsProvider.notifier)
                        .updateTimeLimit(tempLimit.toInt());
                    Navigator.pop(context);
                  },
                  child: const Text('GUARDAR'),
                ),
              ],
            ),
        );
      },
    );
  }
}
