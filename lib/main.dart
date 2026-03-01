import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Imports de dominio/core
import 'package:isla_digital/core/services/services.dart';
import 'package:isla_digital/core/theme/app_theme.dart';
import 'package:isla_digital/core/utils/page_transitions.dart';
import 'package:isla_digital/presentation/providers/app_providers.dart';

// Imports de vistas
import 'package:isla_digital/presentation/views/screens/home_screen.dart';
import 'package:isla_digital/presentation/views/screens/level_select_screen.dart';
import 'package:isla_digital/presentation/views/screens/parental_dashboard_screen.dart';
import 'package:isla_digital/presentation/views/screens/profile_setup_screen.dart';
import 'package:isla_digital/presentation/views/screens/showcase_screen.dart';
import 'package:isla_digital/presentation/widgets/island_background.dart';

void main() async {
  // 1. Garantizar que los canales de plataforma estén listos
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Configuración estética y de hardware
  _configureSystemUI();

  // 3. Inicialización de servicios
  try {
    await Future.wait([
      LocalStorageService.initialize(),
      BackgroundMusicService.initialize(),
    ]);
  } catch (e, stackTrace) {
    debugPrint('Critical Initialization Error: $e\n$stackTrace');
  }

  runApp(
    const ProviderScope(
      child: IslaDigitalApp(),
    ),
  );
}

void _configureSystemUI() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
}

class IslaDigitalApp extends ConsumerWidget {
  const IslaDigitalApp({super.key});

  static const String routeHome = '/home';
  static const String routeProfile = '/profile';
  static const String routeLevels = '/levels';
  static const String routeParental = '/parental';
  static const String routeShowcase = '/showcase';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escuchamos el estado del perfil para decidir la ruta inicial
    final profile = ref.watch(currentProfileProvider);

    return MaterialApp(
      title: 'Isla Digital',
      debugShowCheckedModeBanner: false,
      theme: IslaThemes.lightTheme,
      
      // Si no hay perfil, enviamos a registro. Si hay, a la Home.
      initialRoute: profile == null ? routeProfile : routeHome,
      
      builder: (context, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              const IslandBackground(), 
              if (child != null) child,
            ],
          ),
        );
      },
      onGenerateRoute: _onGenerateRoute,
    );
  }

  /// Manejador de rutas con transiciones.
  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    // Definimos qué widget corresponde a cada ruta
    Widget getScreen() {
      switch (settings.name) {
        case routeHome:
          return const HomeScreen();
        case routeProfile:
          return const ProfileSetupScreen();
        case routeLevels:
          return const LevelSelectScreen();
        case routeParental:
          return const ParentalDashboardScreen();
        case routeShowcase:
          return const ShowcaseScreen();
        default:
          return _errorWidget();
      }
    }

    // Retornamos la transición personalizada pasando el Widget directamente
    return FadeSlideRoute(page: getScreen());
  }

  Widget _errorWidget() {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: const Center(child: Text('La página solicitada no existe.')),
    );
  }

  Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) => _errorWidget());
  }
}