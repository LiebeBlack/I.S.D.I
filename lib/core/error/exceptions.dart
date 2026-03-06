/// Base class for custom exceptions thrown by Data Sources.
/// 
/// These are caught by the Repositories and converted into [Failure] 
/// objects to be returned to the Domain layer safely.
class ServerException implements Exception {
  const ServerException([this.message = 'Server Error']);
  final String message;
}

class CacheException implements Exception {
  const CacheException([this.message = 'Cache Error']);
  final String message;
}

class NetworkException implements Exception {
  const NetworkException([this.message = 'Network Error']);
  final String message;
}
