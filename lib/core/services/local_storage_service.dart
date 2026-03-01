import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:isla_digital/domain/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Servicio de persistencia local usando SharedPreferences
class LocalStorageService {
  static const String _profileKey = 'child_profile';
  static const String _settingsKey = 'parental_settings';
  static const String _badgesKey = 'earned_badges';
  static const String _playTimeKey = 'total_play_time';
  static const String _lastSessionKey = 'last_session';

  static SharedPreferences? _prefs;

  /// Inicializar el servicio. Se debe llamar en el main.dart
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

  /// Getter privado para asegurar que SharedPreferences esté listo
  static SharedPreferences get _p {
    if (_prefs == null) {
      throw Exception('LocalStorageService no ha sido inicializado. Llama a initialize() primero.');
    }
    return _prefs!;
  }

  // --- PERFIL ---

  static Future<bool> saveProfile(ChildProfile profile) async {
    final jsonString = jsonEncode(profile.toJson());
    return await _p.setString(_profileKey, jsonString);
  }

  static ChildProfile? loadProfile() {
    try {
      final jsonString = _p.getString(_profileKey);
      if (jsonString == null || jsonString.isEmpty) return null;
      return ChildProfile.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
    } catch (e) {
      debugPrint('❌ Error al cargar perfil: $e');
      return null;
    }
  }

  static Future<bool> deleteProfile() async {
    return await _p.remove(_profileKey);
  }

  // --- CONFIGURACIÓN PARENTAL ---

  static Future<bool> saveParentalSettings(ParentalSettings settings) async {
    return await _p.setString(_settingsKey, jsonEncode(settings.toJson()));
  }

  static ParentalSettings loadParentalSettings() {
    try {
      final jsonString = _p.getString(_settingsKey);
      if (jsonString == null || jsonString.isEmpty) return const ParentalSettings();
      return ParentalSettings.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
    } catch (e) {
      return const ParentalSettings();
    }
  }

  // --- TIEMPO DE JUEGO Y SESIÓN ---

  static Future<bool> savePlayTime(int minutes) async {
    return await _p.setInt(_playTimeKey, minutes);
  }

  static int loadPlayTime() => _p.getInt(_playTimeKey) ?? 0;

  static Future<int> addPlayTime(int minutes) async {
    final updated = loadPlayTime() + minutes;
    await savePlayTime(updated);
    return updated;
  }

  static Future<bool> saveLastSession() async {
    return await _p.setString(_lastSessionKey, DateTime.now().toIso8601String());
  }

  static DateTime? loadLastSession() {
    final dateString = _p.getString(_lastSessionKey);
    return (dateString != null) ? DateTime.tryParse(dateString) : null;
  }

  static bool isNewDay() {
    final lastSession = loadLastSession();
    if (lastSession == null) return true;
    final now = DateTime.now();
    return lastSession.day != now.day || 
           lastSession.month != now.month || 
           lastSession.year != now.year;
  }

  // --- PROGRESO E INSIGNIAS ---

  static Future<bool> saveLevelProgress(String levelId, int progress) async {
    return await _p.setInt('progress_$levelId', progress);
  }

  static int loadLevelProgress(String levelId) => _p.getInt('progress_$levelId') ?? 0;

  static Future<bool> saveEarnedBadges(List<String> badges) async {
    return await _p.setStringList(_badgesKey, badges);
  }

  static List<String> loadEarnedBadges() => _p.getStringList(_badgesKey) ?? [];

  static Future<List<String>> addBadge(String badgeId) async {
    final badges = loadEarnedBadges();
    if (!badges.contains(badgeId)) {
      badges.add(badgeId);
      await saveEarnedBadges(badges);
    }
    return badges;
  }

  // --- UTILIDADES ---

  static Future<bool> clearAll() async => await _p.clear();

  static Map<String, dynamic> getStatsForParents() {
    return {
      'profile': loadProfile()?.toJson(),
      'totalPlayTimeMinutes': loadPlayTime(),
      'earnedBadges': loadEarnedBadges(),
      'lastSession': loadLastSession()?.toIso8601String(),
      'isNewDay': isNewDay(),
    };
  }
}