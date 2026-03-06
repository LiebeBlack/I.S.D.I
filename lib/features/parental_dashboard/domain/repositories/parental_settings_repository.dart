import 'package:dartz/dartz.dart';
import 'package:isla_digital/core/error/failures.dart';
import 'package:isla_digital/features/parental_dashboard/domain/entities/parental_settings.dart';

/// Segregated interface exclusively for Parental Dashboard settings.
/// 
/// Enforces Interface Segregation Principle by decoupling settings logic 
/// from child profile logic, improving code maintainability.
abstract class IParentalSettingsRepository {
  /// Retrieves the current settings configured by parents.
  Future<Either<Failure, ParentalSettings>> getSettings();
  
  /// Persists changes made to the parental settings.
  Future<Either<Failure, void>> saveSettings(ParentalSettings settings);
}
