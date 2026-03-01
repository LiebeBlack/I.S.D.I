/// Modelo de usuario/niño que usa la aplicación
class ChildProfile {
  // 1. Todos los campos deben ser 'final' para garantizar la inmutabilidad
  ChildProfile({
    required this.id,
    required this.name,
    required this.age,
    this.avatar = 'default',
    DateTime? createdAt,
    this.totalPlayTimeMinutes = 0,
    this.currentLevel = 1,
    Map<String, int>? levelProgress,
    List<String>? earnedBadges,
  })  : createdAt = createdAt ?? DateTime.now(),
        levelProgress = levelProgress ?? {},
        earnedBadges = earnedBadges ?? [];

  factory ChildProfile.fromJson(Map<String, dynamic> json) => ChildProfile(
        id: json['id'] as String,
        name: json['name'] as String,
        age: json['age'] as int,
        avatar: json['avatar'] as String? ?? 'default',
        // Uso de tryParse para evitar crasheos si la fecha viene mal
        createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
        totalPlayTimeMinutes: json['totalPlayTimeMinutes'] as int? ?? 0,
        currentLevel: json['currentLevel'] as int? ?? 1,
        levelProgress: Map<String, int>.from(json['levelProgress'] as Map? ?? {}),
        earnedBadges: List<String>.from(json['earnedBadges'] as List? ?? []),
      );

  final String id;
  final String name;
  final int age;
  final String avatar;
  final DateTime createdAt;
  final int totalPlayTimeMinutes;
  final int currentLevel;
  final Map<String, int> levelProgress;
  final List<String> earnedBadges;

  // 3. Conversión a JSON consistente
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        'avatar': avatar,
        'createdAt': createdAt.toIso8601String(),
        'totalPlayTimeMinutes': totalPlayTimeMinutes,
        'currentLevel': currentLevel,
        'levelProgress': levelProgress,
        'earnedBadges': earnedBadges,
      };

  // 4. CopyWith: Esencial para Riverpod
  // Permite "modificar" el objeto creando uno nuevo con los cambios
  ChildProfile copyWith({
    String? name,
    int? age,
    String? avatar,
    int? totalPlayTimeMinutes,
    int? currentLevel,
    Map<String, int>? levelProgress,
    List<String>? earnedBadges,
  }) =>
      ChildProfile(
        id: id, // El ID nunca cambia
        name: name ?? this.name,
        age: age ?? this.age,
        avatar: avatar ?? this.avatar,
        createdAt: createdAt, // La fecha de creación es constante
        totalPlayTimeMinutes: totalPlayTimeMinutes ?? this.totalPlayTimeMinutes,
        currentLevel: currentLevel ?? this.currentLevel,
        // Usamos Map/List.from para asegurar que se cree una nueva referencia en memoria
        levelProgress: levelProgress ?? Map<String, int>.from(this.levelProgress),
        earnedBadges: earnedBadges ?? List<String>.from(this.earnedBadges),
      );
}