import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isla_digital/core/services/services.dart';
import 'package:isla_digital/domain/models/models.dart';

// --- PROFILE PROVIDER ---

/// Provider para el perfil del niño actual
final currentProfileProvider =
    StateNotifierProvider<ProfileNotifier, ChildProfile?>((ref) {
  return ProfileNotifier()..loadSavedProfile();
});

/// Notifier que maneja el estado del perfil con persistencia
class ProfileNotifier extends StateNotifier<ChildProfile?> {
  ProfileNotifier() : super(null);

  void loadSavedProfile() {
    final savedProfile = LocalStorageService.loadProfile();
    if (savedProfile != null) {
      state = savedProfile;
    }
  }

  Future<void> createProfile(String name, int age, {String avatar = 'default'}) async {
    final profile = ChildProfile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      age: age,
      avatar: avatar,
    );
    state = profile;
    await LocalStorageService.saveProfile(profile);
  }

  Future<void> _updateAndSave(ChildProfile updated) async {
    state = updated;
    await LocalStorageService.saveProfile(updated);
  }

  Future<void> updateProfile({String? name, int? age, String? avatar}) async {
    if (state == null) return;
    final updated = state!.copyWith(
      name: name ?? state!.name,
      age: age ?? state!.age,
      avatar: avatar ?? state!.avatar,
    );
    await _updateAndSave(updated);
  }

  Future<void> addProgress(String levelId, int points) async {
    if (state == null) return;
    final newProgress = Map<String, int>.from(state!.levelProgress);
    final currentPoints = newProgress[levelId] ?? 0;
    newProgress[levelId] = currentPoints + points;

    final updated = state!.copyWith(levelProgress: newProgress);
    await _updateAndSave(updated);
    await LocalStorageService.saveLevelProgress(levelId, newProgress[levelId]!);
  }

  Future<void> unlockLevel(int level) async {
    if (state != null && level > state!.currentLevel) {
      final updated = state!.copyWith(currentLevel: level);
      await _updateAndSave(updated);
    }
  }

  Future<void> addBadge(String badgeId) async {
    if (state == null || state!.earnedBadges.contains(badgeId)) return;
    
    final newBadges = List<String>.from(state!.earnedBadges)..add(badgeId);
    final updated = state!.copyWith(earnedBadges: newBadges);
    await _updateAndSave(updated);
    await LocalStorageService.addBadge(badgeId);
  }

  Future<void> addPlayTime(int minutes) async {
    if (state == null) return;
    final updated = state!.copyWith(
      totalPlayTimeMinutes: state!.totalPlayTimeMinutes + minutes,
    );
    await _updateAndSave(updated);
    await LocalStorageService.addPlayTime(minutes);
  }

  Future<void> clear() async {
    state = null;
    await LocalStorageService.deleteProfile();
  }
}

// --- PARENTAL SETTINGS PROVIDER ---

final parentalSettingsProvider =
    StateNotifierProvider<ParentalSettingsNotifier, ParentalSettings>((ref) {
  return ParentalSettingsNotifier()..loadSavedSettings();
});

class ParentalSettingsNotifier extends StateNotifier<ParentalSettings> {
  ParentalSettingsNotifier() : super(const ParentalSettings());

  void loadSavedSettings() {
    final savedSettings = LocalStorageService.loadParentalSettings();
    state = savedSettings;
  }

  Future<void> _saveSettings(ParentalSettings updated) async {
    state = updated;
    await LocalStorageService.saveParentalSettings(updated);
  }

  Future<void> updateTimeLimit(int minutes) async {
    await _saveSettings(state.copyWith(dailyTimeLimitMinutes: minutes));
  }

  Future<void> toggleSound() async {
    await _saveSettings(state.copyWith(soundEnabled: !state.soundEnabled));
  }

  Future<void> toggleMusic() async {
    await _saveSettings(state.copyWith(musicEnabled: !state.musicEnabled));
  }

  Future<void> addAllowedContact(String contact) async {
    final newContacts = List<String>.from(state.allowedContacts)..add(contact);
    await _saveSettings(state.copyWith(allowedContacts: newContacts));
  }

  Future<void> removeAllowedContact(String contact) async {
    final newContacts = List<String>.from(state.allowedContacts)..remove(contact);
    await _saveSettings(state.copyWith(allowedContacts: newContacts));
  }
}

// --- APP STATE PROVIDER ---

final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((ref) {
  return AppStateNotifier();
});

@immutable
class AppState {
  const AppState({
    this.isLoading = false,
    this.currentRoute,
    this.showCelebration = false,
  });

  final bool isLoading;
  final String? currentRoute;
  final bool showCelebration;

  AppState copyWith({
    bool? isLoading,
    String? currentRoute,
    bool? showCelebration,
  }) {
    return AppState(
      isLoading: isLoading ?? this.isLoading,
      currentRoute: currentRoute ?? this.currentRoute,
      showCelebration: showCelebration ?? this.showCelebration,
    );
  }
}

class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(const AppState());

  void setLoading(bool loading) => state = state.copyWith(isLoading: loading);
  void setRoute(String route) => state = state.copyWith(currentRoute: route);

  void triggerCelebration() {
    state = state.copyWith(showCelebration: true);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) state = state.copyWith(showCelebration: false);
    });
  }
}

// --- LEVEL PROGRESS PROVIDER ---

final levelProgressProvider =
    StateNotifierProvider.family<LevelProgressNotifier, int, String>(
  (ref, levelId) => LevelProgressNotifier(levelId),
);

class LevelProgressNotifier extends StateNotifier<int> {
  LevelProgressNotifier(this.levelId) : super(0);
  final String levelId;

  void addPoints(int points) => state = (state + points).clamp(0, 100);
  void setProgress(int progress) => state = progress.clamp(0, 100);
  void reset() => state = 0;
}