import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isla_digital/core/services/logging_service.dart';
import 'package:isla_digital/features/parental_dashboard/domain/entities/parental_settings.dart';
import 'package:isla_digital/features/parental_dashboard/domain/repositories/parental_settings_repository.dart';
import 'package:isla_digital/injection_container.dart';

class ParentalSettingsNotifier extends Notifier<ParentalSettings> {
  IParentalSettingsRepository get _repository => sl<IParentalSettingsRepository>();

  @override
  ParentalSettings build() => const ParentalSettings(); // Initial, will be loaded

  Future<void> loadSettings() async {
    final result = await _repository.getSettings();
    result.fold(
      (failure) {
        LoggingService.e('SettingsNotifier: Failed to load settings: ${failure.message}');
        // Retain default state if load fails
      },
      (settings) {
        state = settings;
      },
    );
  }

  Future<void> _update(ParentalSettings updated) async {
    final result = await _repository.saveSettings(updated);
    result.fold(
      (failure) {
        LoggingService.e('SettingsNotifier: Failed to save settings: ${failure.message}');
        // Optionally revert to a previous trusted state if pessimistic update is needed
      },
      (_) {
        state = updated; // Optimistic UI update maintained
      },
    );
  }

  Future<void> updateTimeLimit(int minutes) =>
      _update(state.copyWith(dailyTimeLimitMinutes: minutes));
  Future<void> toggleSound() =>
      _update(state.copyWith(soundEnabled: !state.soundEnabled));
  Future<void> toggleMusic() =>
      _update(state.copyWith(musicEnabled: !state.musicEnabled));
}

final parentalSettingsProvider =
    NotifierProvider<ParentalSettingsNotifier, ParentalSettings>(
        ParentalSettingsNotifier.new);
