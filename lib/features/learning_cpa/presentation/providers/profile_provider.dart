import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isla_digital/core/services/logging_service.dart';
import 'package:isla_digital/features/learning_cpa/data/models/child_profile_model.dart';
import 'package:isla_digital/features/learning_cpa/domain/entities/child_profile.dart';
import 'package:isla_digital/features/learning_cpa/domain/repositories/child_profile_repository.dart';
import 'package:isla_digital/injection_container.dart';

class ProfileNotifier extends Notifier<ChildProfile?> {
  IChildProfileRepository get _repository => sl<IChildProfileRepository>();

  @override
  ChildProfile? build() {
    // Feature 6: In-Memory Caching (keepAlive)
    // Prevents the profile state from being destroyed and re-fetched
    // when navigating between major sections, saving CPU cycles.
    ref.keepAlive();
    
    return null; // Initial state. In main we can trigger a load.
  }

  Future<void> loadProfile() async {
    final result = await _repository.getProfile();
    result.fold(
      (failure) {
        LoggingService.e('ProfileNotifier: Failed to load profile: ${failure.message}');
        state = null;
      },
      (profile) {
        state = profile;
      },
    );
  }

  Future<void> createProfile(String name, int age, {String avatar = '0'}) async {
    final profile = ChildProfile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      age: age,
      avatar: avatar,
      createdAt: DateTime.now(),
    );
    await _updateAndSave(profile);
  }

  Future<void> unlockLevel(int levelNumber) async {
    if (state == null) return;
    if (levelNumber > state!.currentLevel) {
      final updatedProfile = (state! as ChildProfileModel).copyWith(currentLevel: levelNumber);
      await _updateAndSave(updatedProfile);
    }
  }

  Future<void> addProgress(
    String levelId,
    int points, {
    int? logic,
    int? creativity,
    int? problemSolving,
  }) async {
    if (state == null) return;

    final newProgress = Map<String, int>.from(state!.levelProgress);
    newProgress[levelId] = (newProgress[levelId] ?? 0) + points;

    final updatedProfile = (state! as ChildProfileModel).copyWith(
      levelProgress: newProgress,
      logicProgress: (state!.logicProgress + (logic ?? 0)).clamp(0, 100),
      creativityProgress:
          (state!.creativityProgress + (creativity ?? 0)).clamp(0, 100),
      problemSolvingProgress:
          (state!.problemSolvingProgress + (problemSolving ?? 0)).clamp(0, 100),
    );

    await _updateAndSave(updatedProfile);
  }

  Future<void> addBadge(String badgeId) async {
    if (state == null || state!.earnedBadges.contains(badgeId)) return;
    final newBadges = List<String>.from(state!.earnedBadges)..add(badgeId);
    final updatedProfile = (state! as ChildProfileModel).copyWith(earnedBadges: newBadges);
    await _updateAndSave(updatedProfile);
  }

  Future<void> _updateAndSave(ChildProfile profile) async {
    final result = await _repository.saveProfile(profile);
    result.fold(
      (failure) {
        LoggingService.e('ProfileNotifier: Failed to save profile progress: ${failure.message}');
        // Optionally revert state here if pessimistic UI updates are preferred.
      },
      (_) {
        state = profile; // Optimistic UI update maintained
      },
    );
  }

  Future<void> resetProgress() async {
    final result = await _repository.deleteProfile();
    result.fold(
      (failure) => LoggingService.e('ProfileNotifier: Failed to delete profile: ${failure.message}'),
      (_) => state = null,
    );
  }
}

final currentProfileProvider =
    NotifierProvider<ProfileNotifier, ChildProfile?>(ProfileNotifier.new);
