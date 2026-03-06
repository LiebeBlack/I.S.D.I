import 'package:equatable/equatable.dart';

/// The core domain entity representing a child user within the application.
/// 
/// Encapsulates all defining characteristics, progress metrics, and pedagogical 
/// metadata required to tailor the CPA (Concrete-Pictorial-Abstract) learning 
/// experience to the individual learner.
class ChildProfile extends Equatable {

  const ChildProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.avatar,
    required this.createdAt,
    this.totalPlayTimeMinutes = 0,
    this.currentLevel = 1,
    this.levelProgress = const {},
    this.earnedBadges = const [],
    this.logicProgress = 0,
    this.creativityProgress = 0,
    this.problemSolvingProgress = 0,
  })  : assert(age >= 0, 'Age cannot be negative'),
        assert(totalPlayTimeMinutes >= 0, 'Play time cannot be negative'),
        assert(currentLevel >= 1, 'Current level must be at least 1'),
        assert(logicProgress >= 0 && logicProgress <= 100, 'Logic progress must be between 0 and 100'),
        assert(creativityProgress >= 0 && creativityProgress <= 100, 'Creativity progress must be between 0 and 100'),
        assert(problemSolvingProgress >= 0 && problemSolvingProgress <= 100, 'Problem solving progress must be between 0 and 100');
  /// Unique identifier generated upon profile creation.
  final String id;
  /// Display name used in the UI, usually restricted to first names for privacy.
  final String name;
  /// Age in years, used to dynamically scale the difficulty of initial levels.
  final int age;
  /// Asset path to the locally selected avatar image.
  final String avatar;
  /// Timestamp marking when the profile was initially created.
  final DateTime createdAt;
  /// Aggregate session duration tracked across all device usage.
  final int totalPlayTimeMinutes;
  /// The absolute highest level the child is currently allowed to access.
  final int currentLevel;
  /// Mapping of `levelId` to a completion percentage (0-100).
  final Map<String, int> levelProgress;
  /// List of unique standard/special IDs representing unlocked achievements.
  final List<String> earnedBadges;
  
  // Pedagogical Progress Metrics (Scale 0-100)
  /// Represents the child's assessed proficiency in structural logic puzzles.
  final int logicProgress; 
  /// Represents the child's assessed proficiency in open-ended coloring/drawing.
  final int creativityProgress; 
  /// Represents the child's assessed proficiency in multi-step challenges.
  final int problemSolvingProgress;

  /// Creates a copy of this profile with the given fields replaced with the new values.
  ChildProfile copyWith({
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
  }) => ChildProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      totalPlayTimeMinutes: totalPlayTimeMinutes ?? this.totalPlayTimeMinutes,
      currentLevel: currentLevel ?? this.currentLevel,
      levelProgress: levelProgress ?? this.levelProgress,
      earnedBadges: earnedBadges ?? this.earnedBadges,
      logicProgress: logicProgress ?? this.logicProgress,
      creativityProgress: creativityProgress ?? this.creativityProgress,
      problemSolvingProgress: problemSolvingProgress ?? this.problemSolvingProgress,
    );

  @override
  List<Object?> get props => [
        id,
        name,
        age,
        avatar,
        createdAt,
        totalPlayTimeMinutes,
        currentLevel,
        levelProgress,
        earnedBadges,
        logicProgress,
        creativityProgress,
        problemSolvingProgress,
      ];
}
