Copyright (c) 2026 Yoangel De Dios Nícolas Gómez Gómez/Isla Digital. Todos los derechos reservados.
# Isla Digital

Aplicación educativa multiplataforma para niños de 3-8 años de Nueva Esparta, Venezuela.

## Descripción

Isla Digital transforma el uso del teléfono de simple entretenimiento en una herramienta de aprendizaje sano y productivo para niños en edad preescolar.

## Características

### 5 Niveles Educativos

1. **Mi Primer Encuentro** - Simulación interactiva de encendido, botones y gestos
2. **Conectados** - Llamadas y mensajes seguros
3. **Explorador Seguro** - Detective de Internet
4. **Super Tareas** - Calculadora con frutas y cámara
5. **Pequeño Artista** - Dibujo y ritmos musicales

### Sistema de Gamificación

- Insignias Margariteñas ("Perla de Sabiduría", "Capitán del Teclado", etc.)
- Barras de progreso visuales
- Celebraciones animadas

### Control Parental

- Dashboard protegido por bloqueo matemático
- Control de tiempo de uso
- Monitoreo de progreso académico

## Estética Cultural

Diseño inspirado en la Isla de Margarita con:
- Colores del océano y playas
- Vegetación tropical
- Atardeceres caribeños

## Requisitos Técnicos

- Flutter SDK >= 3.0.0
- Dart >= 3.0.0
- Soporte para Android, Windows y Linux

## Instalación

```bash
# Clonar el repositorio
cd isla_digital

# Instalar dependencias
flutter pub get

# Ejecutar en modo debug
flutter run
```

## Estructura del Proyecto

```
lib/
├── core/
│   ├── models/          # Perfil, Insignias
│   ├── providers/       # Estado con Riverpod
│   └── theme/          # Colores y tipografía
├── ui/
│   ├── levels/         # Niveles 1-5
│   ├── screens/        # Pantallas principales
│   └── widgets/        # Componentes reutilizables
└── main.dart
```

## Dependencias Principales

- `flutter_riverpod` - Gestión de estado
- `google_fonts` - Tipografía accesible
- `flutter_svg` - Gráficos vectoriales
- `lottie` - Animaciones
- `audioplayers` - Sonidos y música
- `shared_preferences` - Almacenamiento local

## Arquitectura

- **Modular**: Cada nivel es independiente
- **Ligera**: Optimizada para dispositivos de gama baja
- **State Management**: Riverpod para reactividad


## Licencia

Proyecto educativo para la comunidad de Nueva Esparta, Venezuela.

## Contacto
[![Telegram](https://img.shields.io/badge/Telegram-Asistencia-000000?style=for-the-badge&logo=telegram&logoColor=white)](https://t.me/LiebeBlack) 
