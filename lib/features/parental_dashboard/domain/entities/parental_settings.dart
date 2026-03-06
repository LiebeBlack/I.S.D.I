import 'package:equatable/equatable.dart';

/// The core domain entity representing parental control configurations.
/// 
/// Dictates system-wide behaviors regarding time limits and multimedia 
/// settings, ensuring the app adheres to the parent's desired boundaries.
class ParentalSettings extends Equatable {

  const ParentalSettings({
    this.dailyTimeLimitMinutes = 60,
    this.soundEnabled = true,
    this.musicEnabled = true,
  }) : assert(dailyTimeLimitMinutes >= 0, 'Time limit cannot be negative');

  factory ParentalSettings.fromJson(Map<String, dynamic> json) {
    try {
      final timeLimit = (json['dailyTimeLimitMinutes'] as num?)?.toInt() ?? 60;
      return ParentalSettings(
        dailyTimeLimitMinutes: timeLimit < 0 ? 60 : timeLimit, // Fallback on negative corruption
        soundEnabled: json['soundEnabled'] as bool? ?? true,
        musicEnabled: json['musicEnabled'] as bool? ?? true,
      );
    } catch (e) {
      // Blindaje (Zero-Errors): Fallback to defaults if parsing fails entirely
      return const ParentalSettings();
    }
  }
  /// Maximum allowed playtime in minutes before the `SessionTimeoutManager` locks the app.
  final int dailyTimeLimitMinutes;
  /// Global toggle for interactive sound effects.
  final bool soundEnabled;
  /// Global toggle for continuous background music loops.
  final bool musicEnabled;

  @override
  List<Object?> get props => [dailyTimeLimitMinutes, soundEnabled, musicEnabled];

  ParentalSettings copyWith({
    int? dailyTimeLimitMinutes,
    bool? soundEnabled,
    bool? musicEnabled,
  }) => ParentalSettings(
      dailyTimeLimitMinutes:
          dailyTimeLimitMinutes ?? this.dailyTimeLimitMinutes,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      musicEnabled: musicEnabled ?? this.musicEnabled,
    );

  Map<String, dynamic> toJson() => {
        'dailyTimeLimitMinutes': dailyTimeLimitMinutes,
        'soundEnabled': soundEnabled,
        'musicEnabled': musicEnabled,
      };
}
