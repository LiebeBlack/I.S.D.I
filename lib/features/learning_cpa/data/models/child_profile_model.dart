import 'package:isla_digital/features/learning_cpa/domain/entities/child_profile.dart';

class ChildProfileModel extends ChildProfile {
  const ChildProfileModel({
    required super.id,
    required super.name,
    required super.age,
    required super.avatar,
    required super.createdAt,
    super.totalPlayTimeMinutes = 0,
    super.currentLevel = 1,
    super.levelProgress = const {},
    super.earnedBadges = const [],
    super.logicProgress = 0,
    super.creativityProgress = 0,
    super.problemSolvingProgress = 0,
  });

  factory ChildProfileModel.fromJson(Map<String, dynamic> json) {
    try {
      return ChildProfileModel(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? 'Explorador',
        age: int.tryParse(json['age']?.toString() ?? '') ?? 0,
        avatar: json['avatar']?.toString() ?? 'default',
        createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
            DateTime.now(),
        totalPlayTimeMinutes:
            int.tryParse(json['totalPlayTimeMinutes']?.toString() ?? '') ?? 0,
        currentLevel: int.tryParse(json['currentLevel']?.toString() ?? '') ?? 1,
        levelProgress: Map<String, int>.from(json['levelProgress'] as Map? ?? {}),
        earnedBadges: List<String>.from(json['earnedBadges'] as List? ?? []),
        logicProgress: int.tryParse(json['logicProgress']?.toString() ?? '') ?? 0,
        creativityProgress: int.tryParse(json['creativityProgress']?.toString() ?? '') ?? 0,
        problemSolvingProgress: int.tryParse(json['problemSolvingProgress']?.toString() ?? '') ?? 0,
      );
    } catch (e) {
      // Blindaje (Zero-Errors): Fallback to defaults if parsing structure fails entirely
      return ChildProfileModel(
        id: 'error_fallback',
        name: 'Explorador',
        age: 0,
        avatar: 'default',
        createdAt: DateTime.now(),
      );
    }
  }

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
        'logicProgress': logicProgress,
        'creativityProgress': creativityProgress,
        'problemSolvingProgress': problemSolvingProgress,
      };

  @override
  ChildProfileModel copyWith({
    String? id,
    String? name,
    int? age,
    String? avatar,
    DateTime? createdAt,
    int? totalPlayTimeMinutes,
    int? currentLevel,
    Map<String, int>? levelProgress,
    List<String>? earnedBadges,
    int? logicProgress,
    int? creativityProgress,
    int? problemSolvingProgress,
  }) => ChildProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      totalPlayTimeMinutes: totalPlayTimeMinutes ?? this.totalPlayTimeMinutes,
      currentLevel: currentLevel ?? this.currentLevel,
      levelProgress: levelProgress ?? Map<String, int>.from(this.levelProgress),
      earnedBadges: earnedBadges ?? List<String>.from(this.earnedBadges),
      logicProgress: logicProgress ?? this.logicProgress,
      creativityProgress: creativityProgress ?? this.creativityProgress,
      problemSolvingProgress: problemSolvingProgress ?? this.problemSolvingProgress,
    );
}
