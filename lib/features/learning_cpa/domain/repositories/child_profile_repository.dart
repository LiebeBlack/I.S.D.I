import 'package:dartz/dartz.dart';
import 'package:isla_digital/core/error/failures.dart';
import 'package:isla_digital/features/learning_cpa/domain/entities/child_profile.dart';

/// Segregated interface exclusively for Child Profile operations.
/// 
/// Implements the Result Pattern (`Either<Failure, T>`) for robust, 
/// explicit error handling, preventing exceptions from crashing the app.
abstract class IChildProfileRepository {
  /// Retrieves the active child profile from storage.
  Future<Either<Failure, ChildProfile?>> getProfile();
  
  /// Persists the active child profile to storage.
  Future<Either<Failure, void>> saveProfile(ChildProfile profile);
  
  /// Deletes the child profile and all associated progress.
  Future<Either<Failure, void>> deleteProfile();
}
