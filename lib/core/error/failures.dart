import 'package:equatable/equatable.dart';

/// Base class for all handled errors within the application domain.
/// 
/// By extending [Failure], we force repositories and use cases to return
/// explicit error states (using Right/Left from `dartz`), preventing unexpected
/// exceptions from propagating and crashing the UI layer.
abstract class Failure extends Equatable {
  
  const Failure(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}

// =============================================================================
// SPECIFIC DOMAIN FAILURES
// =============================================================================

/// Generated when a device is offline and cached data is unavailable.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection available.']);
}

/// Generated when a local storage or caching operation fails (e.g., SQLite/SecureVault errors).
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Failed to access local device storage.']);
}

/// Generated when the server returns an explicit error or unexpected payload.
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'An unexpected server error occurred.']);
}

/// Generated during unauthorized access attempts (e.g., parental gate failures).
class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed or session expired.']);
}

/// Generic failure for unanticipated errors that don't fit specific categories.
class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unknown system error occurred.']);
}
