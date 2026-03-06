import 'package:dartz/dartz.dart';
import 'package:isla_digital/core/error/exceptions.dart';
import 'package:isla_digital/core/error/failures.dart';
import 'package:isla_digital/core/services/local_storage_service.dart';
import 'package:isla_digital/features/learning_cpa/data/models/child_profile_model.dart';
import 'package:isla_digital/features/learning_cpa/domain/entities/child_profile.dart';
import 'package:isla_digital/features/learning_cpa/domain/repositories/child_profile_repository.dart';

/// Concrete implementation of [IChildProfileRepository].
/// 
/// Interacts with [LocalStorageService] and catches any unexpected 
/// [Exception], returning a clean [Failure] to the domain layer.
class ChildProfileRepositoryImpl implements IChildProfileRepository {
  @override
  Future<Either<Failure, ChildProfile?>> getProfile() async {
    try {
      final profile = LocalStorageService.loadProfile();
      return Right(profile);
    } on CacheException {
      return const Left(CacheFailure());
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveProfile(ChildProfile profile) async {
    try {
      final model = ChildProfileModel(
        id: profile.id,
        name: profile.name,
        age: profile.age,
        avatar: profile.avatar,
        createdAt: profile.createdAt,
        totalPlayTimeMinutes: profile.totalPlayTimeMinutes,
        currentLevel: profile.currentLevel,
        levelProgress: profile.levelProgress,
        earnedBadges: profile.earnedBadges,
        logicProgress: profile.logicProgress,
        creativityProgress: profile.creativityProgress,
        problemSolvingProgress: profile.problemSolvingProgress,
      );
      await LocalStorageService.saveProfile(model);
      return const Right(null);
    } on CacheException {
      return const Left(CacheFailure());
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProfile() async {
    try {
      await LocalStorageService.deleteProfile();
      return const Right(null);
    } on CacheException {
      return const Left(CacheFailure());
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
