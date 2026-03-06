import 'package:dartz/dartz.dart';
import 'package:isla_digital/core/error/exceptions.dart';
import 'package:isla_digital/core/error/failures.dart';
import 'package:isla_digital/core/services/local_storage_service.dart';
import 'package:isla_digital/features/parental_dashboard/domain/entities/parental_settings.dart';
import 'package:isla_digital/features/parental_dashboard/domain/repositories/parental_settings_repository.dart';

/// Concrete implementation of [IParentalSettingsRepository].
/// 
/// Interacts with [LocalStorageService] explicitly for settings data,
/// mapping low-level storage exceptions into safe [Failure] objects.
class ParentalSettingsRepositoryImpl implements IParentalSettingsRepository {
  @override
  Future<Either<Failure, ParentalSettings>> getSettings() async {
    try {
      final settings = LocalStorageService.loadParentalSettings();
      return Right(settings);
    } on CacheException {
      return const Left(CacheFailure('Could not load parental settings.'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveSettings(ParentalSettings settings) async {
    try {
      await LocalStorageService.saveParentalSettings(settings);
      return const Right(null);
    } on CacheException {
      return const Left(CacheFailure('Could not save parental settings.'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
