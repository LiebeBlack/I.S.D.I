import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class BackgroundMusicService {
  static final AudioPlayer _player = AudioPlayer();
  
  // Variables de estado interno
  static bool _isPlaying = false;
  static bool _isMuted = false;
  static double _currentVolume = 1;

  /// Inicialización global del servicio
  static Future<void> initialize() async {
    try {
      // Configuramos el modo de liberación para que la música se repita infinitamente
      await _player.setReleaseMode(ReleaseMode.loop);
      
      // Es buena práctica precargar el archivo para evitar delay la primera vez
      await _player.setSource(AssetSource('audio/music/01.mp3'));
      
      debugPrint('🎵 BackgroundMusicService inicializado correctamente');
    } catch (e) {
      debugPrint('❌ Error initializing background music: $e');
    }
  }

  /// Inicia la reproducción desde el principio
  static Future<void> startMusic() async {
    if (_isMuted) return;
    try {
      await _player.play(AssetSource('audio/music/01.mp3'));
      _isPlaying = true;
    } catch (e) {
      debugPrint('❌ Error playing background music: $e');
    }
  }

  /// Detiene la música por completo
  static Future<void> stopMusic() async {
    try {
      await _player.stop();
      _isPlaying = false;
    } catch (e) {
      debugPrint('❌ Error stopping background music: $e');
    }
  }

  /// Pausa la música (mantiene la posición actual)
  static Future<void> pauseMusic() async {
    if (!_isPlaying) return;
    try {
      await _player.pause();
      _isPlaying = false;
    } catch (e) {
      debugPrint('❌ Error pausing background music: $e');
    }
  }

  /// Reanuda la música desde donde se pausó
  static Future<void> resumeMusic() async {
    if (_isPlaying || _isMuted) return;
    try {
      await _player.resume();
      _isPlaying = true;
    } catch (e) {
      debugPrint('❌ Error resuming background music: $e');
    }
  }

  /// Control inteligente del volumen (Mute/Unmute)
  static Future<void> setMute(bool mute) async {
    _isMuted = mute;
    try {
      await _player.setVolume(mute ? 0 : _currentVolume);
      
      // Si quitamos el silencio y no estaba sonando, la reanudamos
      if (!mute && !_isPlaying) {
        await resumeMusic();
      }
    } catch (e) {
      debugPrint('❌ Error toggling mute: $e');
    }
  }

  /// Ajustar el volumen (0.0 a 1.0)
  static Future<void> setVolume(double volume) async {
    _currentVolume = volume.clamp(0.0, 1.0);
    if (!_isMuted) {
      await _player.setVolume(_currentVolume);
    }
  }

  // Getters para consultar el estado desde la UI
  static bool get isPlaying => _isPlaying;
  static bool get isMuted => _isMuted;
}