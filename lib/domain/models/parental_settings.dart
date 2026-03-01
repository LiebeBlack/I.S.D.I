/// Modelo para la configuración parental y control de tiempo
class ParentalSettings {
  const ParentalSettings({
    this.dailyTimeLimitMinutes = 30,
    this.soundEnabled = true,
    this.musicEnabled = true,
    this.notificationsEnabled = true,
    this.allowedContacts = const [],
    this.lastAccess,
  });

  factory ParentalSettings.fromJson(Map<String, dynamic> json) {
    return ParentalSettings(
      dailyTimeLimitMinutes: json['dailyTimeLimitMinutes'] as int? ?? 30,
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      musicEnabled: json['musicEnabled'] as bool? ?? true,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      allowedContacts: List<String>.from(json['allowedContacts'] as List? ?? []),
      // Manejo seguro de la fecha de último acceso
      lastAccess: json['lastAccess'] != null 
          ? DateTime.tryParse(json['lastAccess'] as String) 
          : null,
    );
  }

  final int dailyTimeLimitMinutes;
  final bool soundEnabled;
  final bool musicEnabled;
  final bool notificationsEnabled;
  final List<String> allowedContacts;
  final DateTime? lastAccess;

  /// Copia el objeto creando una nueva instancia (esencial para Riverpod)
  ParentalSettings copyWith({
    int? dailyTimeLimitMinutes,
    bool? soundEnabled,
    bool? musicEnabled,
    bool? notificationsEnabled,
    List<String>? allowedContacts,
    DateTime? lastAccess,
  }) {
    return ParentalSettings(
      dailyTimeLimitMinutes: dailyTimeLimitMinutes ?? this.dailyTimeLimitMinutes,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      musicEnabled: musicEnabled ?? this.musicEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      // Creamos una nueva lista para asegurar que Riverpod detecte el cambio
      allowedContacts: allowedContacts ?? List<String>.from(this.allowedContacts),
      lastAccess: lastAccess ?? this.lastAccess,
    );
  }

  /// Serializa el objeto a un Map para persistencia en LocalStorage
  Map<String, dynamic> toJson() => {
        'dailyTimeLimitMinutes': dailyTimeLimitMinutes,
        'soundEnabled': soundEnabled,
        'musicEnabled': musicEnabled,
        'notificationsEnabled': notificationsEnabled,
        'allowedContacts': allowedContacts,
        'lastAccess': lastAccess?.toIso8601String(),
      };
}