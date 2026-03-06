import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:isla_digital/features/learning_cpa/data/models/child_profile_model.dart';
import 'package:isla_digital/features/learning_cpa/domain/entities/child_profile.dart';
import 'package:isla_digital/features/parental_dashboard/domain/entities/parental_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Core persistent storage service utilizing [SharedPreferences].
/// 
/// Handles synchronous, unencrypted data persistence for non-sensitive data
/// like game progress, playtime tracking, and basic profile info. For sensitive
/// information (like PINs/Tokens), `SecureStorageService` is used instead.
class LocalStorageService {
  static const String _profileKey = 'child_profile';
  static const String _settingsKey = 'parental_settings';
  static const String _badgesKey = 'earned_badges';
  static const String _playTimeKey = 'total_play_time';
  static const String _lastSessionKey = 'last_session';
  static const String _levelProgressPrefix = 'progress_';

  static SharedPreferences? _prefs;

  /// Initializes the underlying storage instance.
  /// 
  /// Must be awaited during the app bootstrap phase before any other 
  /// storage operations are attempted.
  static Future<void> initialize() async {
    if (_prefs != null) return;
    try {
      _prefs = await SharedPreferences.getInstance();
      debugPrint('💾 LocalStorageService: Inicializado correctamente');
    } catch (e) {
      debugPrint('❌ Error al inicializar SharedPreferences: $e');
      rethrow;
    }
  }

  static SharedPreferences get _p {
    if (_prefs == null) {
      throw Exception(
          'LocalStorageService no inicializado. Llama a initialize() primero.');
    }
    return _prefs!;
  }

  // --- PERFIL ---

  /// Persists the active [ChildProfile] to local storage.
  static Future<bool> saveProfile(ChildProfile profile) async {
    final profileJson = jsonEncode((profile as ChildProfileModel).toJson());
    return await _p.setString(_profileKey, profileJson);
  }

  /// Retrieves the active [ChildProfile] from local storage.
  /// 
  /// Returns `null` if no profile has been saved yet (e.g., first launch).
  static ChildProfile? loadProfile() {
    final jsonString = _p.getString(_profileKey);
    if (jsonString == null || jsonString.isEmpty) return null;

    try {
      final dynamic decoded = jsonDecode(jsonString);
      final Map<String, dynamic> map =
          Map<String, dynamic>.from(decoded as Map);
      return ChildProfileModel.fromJson(map);
    } catch (e) {
      debugPrint('❌ Error al deserializar perfil: $e');
      return null;
    }
  }

  /// Deletes the currently stored [ChildProfile] from disk.
  static Future<bool> deleteProfile() => _p.remove(_profileKey);

  // --- CONFIGURACIÓN PARENTAL ---

  /// Persists parental settings preferences.
  static Future<bool> saveParentalSettings(ParentalSettings settings) async => await _p.setString(_settingsKey, jsonEncode(settings.toJson()));

  /// Retrieves stored parent configurations. Returns defaults if empty.
  static ParentalSettings loadParentalSettings() {
    final jsonString = _p.getString(_settingsKey);
    if (jsonString == null) return const ParentalSettings();

    try {
      final dynamic decoded = jsonDecode(jsonString);
      final Map<String, dynamic> map =
          Map<String, dynamic>.from(decoded as Map);
      return ParentalSettings.fromJson(map);
    } catch (e) {
      return const ParentalSettings();
    }
  }

  // --- TIEMPO DE JUEGO Y SESIÓN ---

  /// Overwrites the total accumulated play time locally.
  static Future<bool> savePlayTime(int minutes) =>
      _p.setInt(_playTimeKey, minutes);

  /// Retrieves total play time. Returns 0 if none stored.
  static int loadPlayTime() => _p.getInt(_playTimeKey) ?? 0;

  /// Atomically increments the total playtime by the specified [minutes].
  static Future<int> addPlayTime(int minutes) async {
    final current = loadPlayTime();
    final updated = current + minutes;
    await savePlayTime(updated);
    return updated;
  }

  /// Records the current timestamp as the last known active session.
  static Future<bool> saveLastSession() => _p.setString(_lastSessionKey, DateTime.now().toIso8601String());

  /// Retrieves the timestamp of the last active app session.
  static DateTime? loadLastSession() {
    final dateString = _p.getString(_lastSessionKey);
    return (dateString != null) ? DateTime.tryParse(dateString) : null;
  }

  /// Computes whether midnight has passed since the user's last session.
  static bool isNewDay() {
    final lastSession = loadLastSession();
    if (lastSession == null) return true;

    final now = DateTime.now();
    return lastSession.year != now.year ||
        lastSession.month != now.month ||
        lastSession.day != now.day;
  }

  // --- PROGRESO E INSIGNIAS ---

  /// Persists progress state for a specific learning level.
  static Future<bool> saveLevelProgress(String levelId, int progress) => _p.setInt('$_levelProgressPrefix$levelId', progress);

  /// Retrieves progress state for a level. Returns 0 if unvisited.
  static int loadLevelProgress(String levelId) => _p.getInt('$_levelProgressPrefix$levelId') ?? 0;

  /// Overwrites the entire list of earned badges.
  static Future<bool> saveEarnedBadges(List<String> badges) => _p.setStringList(_badgesKey, badges);

  /// Retrieves all earned badge identifiers.
  static List<String> loadEarnedBadges() => _p.getStringList(_badgesKey) ?? [];

  /// Adds a unique badge to the earned list if not already present.
  static Future<List<String>> addBadge(String badgeId) async {
    final badges = loadEarnedBadges();
    if (!badges.contains(badgeId)) {
      final updatedBadges = List<String>.from(badges)..add(badgeId);
      await saveEarnedBadges(updatedBadges);
      return updatedBadges;
    }
    return badges;
  }

  // --- UTILIDADES ---

  /// Wipes all data stored within the shared preferences. Unrecoverable.
  static Future<bool> clearAll() => _p.clear();

  /// Aggregates basic metrics specifically formatted for the Parental Dashboard display.
  static Map<String, dynamic> getStatsForParents() => {
      'profileName': loadProfile()?.name ?? 'Sin nombre',
      'totalPlayTimeMinutes': loadPlayTime(),
      'badgesCount': loadEarnedBadges().length,
      'lastActive': loadLastSession()?.toIso8601String() ?? 'Nunca',
      'isNewDay': isNewDay(),
    };
}
