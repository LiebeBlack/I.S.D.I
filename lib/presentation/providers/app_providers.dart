import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isla_digital/core/services/services.dart';
import 'package:isla_digital/domain/models/models.dart';

// --- PROFILE PROVIDER (Modern Notifier) ---

/// Proveedor para gestionar el perfil del niño.
/// Usamos [Notifier] para una gestión de estado más limpia y moderna.
class ProfileNotifier extends Notifier<ChildProfile?> {
  @override
  ChildProfile? build() {
    // Inicializamos el estado desde el servicio de persistencia
    return LocalStorageService.loadProfile();
  }

  // --- MÉTODOS DE ACCIÓN ---

  Future<void> createProfile(
    String name, 
    int age, {
    String avatar = '0',
  }) async {
    final profile = ChildProfile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      age: age,
      avatar: avatar,
      levelProgress: const {},
      earnedBadges: const [],
      currentLevel: 1,
      totalPlayTimeMinutes: 0,
    );
    await _updateAndSave(profile);
  }

  Future<void> unlockLevel(int levelNumber) async {
    if (state == null) return;
    
    if (levelNumber > state!.currentLevel) {
      final updatedProfile = state!.copyWith(currentLevel: levelNumber);
      await _updateAndSave(updatedProfile);
      debugPrint('🎉 ¡Nivel $levelNumber desbloqueado!');
    }
  }

  Future<void> addProgress(String levelId, int points) async {
    if (state == null) return;

    final newProgress = Map<String, int>.from(state!.levelProgress);
    newProgress[levelId] = (newProgress[levelId] ?? 0) + points;

    final updatedProfile = state!.copyWith(levelProgress: newProgress);
    await _updateAndSave(updatedProfile);
    await LocalStorageService.saveLevelProgress(levelId, newProgress[levelId]!);
  }

  Future<void> addBadge(String badgeId) async {
    if (state == null || state!.earnedBadges.contains(badgeId)) return;
    
    final newBadges = List<String>.from(state!.earnedBadges)..add(badgeId);
    final updatedProfile = state!.copyWith(earnedBadges: newBadges);
    
    await _updateAndSave(updatedProfile);
    await LocalStorageService.addBadge(badgeId);
  }

  Future<void> _updateAndSave(ChildProfile profile) async {
    state = profile;
    await LocalStorageService.saveProfile(profile);
  }

  Future<void> resetProgress() async {
    state = null;
    await LocalStorageService.deleteProfile();
  }
}

final currentProfileProvider = NotifierProvider<ProfileNotifier, ChildProfile?>(() {
  return ProfileNotifier();
});

// --- PARENTAL SETTINGS PROVIDER ---

class ParentalSettingsNotifier extends Notifier<ParentalSettings> {
  @override
  ParentalSettings build() {
    return LocalStorageService.loadParentalSettings();
  }

  Future<void> _update(ParentalSettings updated) async {
    state = updated;
    await LocalStorageService.saveParentalSettings(updated);
  }

  Future<void> updateTimeLimit(int minutes) => _update(state.copyWith(dailyTimeLimitMinutes: minutes));
  Future<void> toggleSound() => _update(state.copyWith(soundEnabled: !state.soundEnabled));
  Future<void> toggleMusic() => _update(state.copyWith(musicEnabled: !state.musicEnabled));
}

final parentalSettingsProvider = NotifierProvider<ParentalSettingsNotifier, ParentalSettings>(() {
  return ParentalSettingsNotifier();
});

// --- APP UI STATE PROVIDER ---

@immutable
class AppState {
  const AppState({
    this.isLoading = false,
    this.showCelebration = false,
  });

  final bool isLoading;
  final bool showCelebration;

  AppState copyWith({bool? isLoading, bool? showCelebration}) {
    return AppState(
      isLoading: isLoading ?? this.isLoading,
      showCelebration: showCelebration ?? this.showCelebration,
    );
  }
}

class AppStateNotifier extends Notifier<AppState> {
  @override
  AppState build() => const AppState();

  void setLoading(bool loading) => state = state.copyWith(isLoading: loading);
  
  void triggerCelebration() {
    state = state.copyWith(showCelebration: true);
    // En Notifier, no necesitamos 'mounted', Riverpod gestiona el ciclo de vida.
    Future.delayed(const Duration(seconds: 3), () {
      state = state.copyWith(showCelebration: false);
    });
  }
}

final appStateProvider = NotifierProvider<AppStateNotifier, AppState>(() => AppStateNotifier());

// --- LEVEL PROGRESS PROVIDER ---

/// Proveedor que devuelve un [int] (puntos) para un nivel específico.
final levelProgressProvider = Provider.family<int, String>((ref, levelId) {
  final profile = ref.watch(currentProfileProvider);
  // Garantizamos el retorno de un int, nunca dynamic.
  return profile?.levelProgress[levelId] ?? 0;
});