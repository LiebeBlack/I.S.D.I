import 'package:get_it/get_it.dart';
import 'package:isla_digital/features/learning_cpa/data/repositories/child_profile_repository_impl.dart';
import 'package:isla_digital/features/learning_cpa/domain/repositories/child_profile_repository.dart';
import 'package:isla_digital/features/parental_dashboard/data/repositories/parental_settings_repository_impl.dart';
import 'package:isla_digital/features/parental_dashboard/domain/repositories/parental_settings_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Feature 18 & 19: Interface Segregation and Dependency Inversion
  sl.registerLazySingleton<IChildProfileRepository>(
    ChildProfileRepositoryImpl.new,
  );

  sl.registerLazySingleton<IParentalSettingsRepository>(
    ParentalSettingsRepositoryImpl.new,
  );
  // LocalStorageService is static, but we could wrap it if needed.
  // For now, we'll just initialize it in main.dart.
}
