import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Importaciones de tu proyecto
import 'package:isla_digital/core/services/services.dart';
import 'package:isla_digital/core/theme/app_theme.dart';
import 'package:isla_digital/core/utils/page_transitions.dart';
import 'package:isla_digital/presentation/providers/app_providers.dart';
import 'package:isla_digital/presentation/views/screens/home_screen.dart';
import 'package:isla_digital/presentation/views/screens/level_select_screen.dart';
import 'package:isla_digital/presentation/views/screens/parental_dashboard_screen.dart';
import 'package:isla_digital/presentation/views/screens/profile_setup_screen.dart';
import 'package:isla_digital/presentation/views/screens/showcase_screen.dart';
import 'package:isla_digital/presentation/widgets/island_background.dart'; // Importante para el fondo global

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await LocalStorageService.initialize();
    await BackgroundMusicService.initialize();
  } catch (e) {
    debugPrint('Error durante la inicialización: $e');
  }

  runApp(
    const ProviderScope(
      child: IslaDigitalApp(),
    ),
  );
}

class IslaDigitalApp extends ConsumerWidget {
  const IslaDigitalApp({super.key});

  static final Map<String, Widget Function()> _routes = {
    '/home': () => const HomeScreen(),
    '/profile': () => const ProfileSetupScreen(),
    '/levels': () => const LevelSelectScreen(),
    '/parental': () => const ParentalDashboardScreen(),
    '/showcase': () => const ShowcaseScreen(),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileProvider);

    return MaterialApp(
      title: 'Isla Digital',
      debugShowCheckedModeBanner: false,
      theme: IslaThemes.lightTheme,
      initialRoute: profile == null ? '/profile' : '/home',
      
      builder: (context, child) {
        return Scaffold(
          body: Stack(
            children: [
              const IslandBackground(), 
              if (child != null) child,
            ],
          ),
        );
      },
      
      onGenerateRoute: (settings) {
        final builder = _routes[settings.name];
        if (builder != null) {
          return FadeSlideRoute(page: builder());
        }
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Ruta no encontrada')),
          ),
        );
      },
    );
  }
}