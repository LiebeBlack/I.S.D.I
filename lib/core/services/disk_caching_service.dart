import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:isla_digital/core/services/logging_service.dart';

/// Pre-configured disk caching engine for the I.S.D.I application.
/// 
/// Designed to aggressively cache multimedia assets (images, audio, remote Lotties)
/// to ensure the app functions seamlessly in low-connectivity areas in Venezuela,
/// minimizing redundant network requests and disk I/O bottlenecks.
class DiskCachingService {

  DiskCachingService._();
  /// Defines the strict caching rules for the application.
  static final DefaultCacheManager instance = DefaultCacheManager();
  
  /// Specifically tuned CacheManager for heavy pedagogical media.
  static final CacheManager mediaCache = CacheManager(
    Config(
      'isla_digital_media_cache',
      stalePeriod: const Duration(days: 30),
      maxNrOfCacheObjects: 200,
      repo: JsonCacheInfoRepository(databaseName: 'isla_media_cache.db'),
      fileService: HttpFileService(),
    ),
  );

  /// Pre-warms the cache with a specific URL. Useful during onboarding.
  static Future<void> preWarmCache(String url) async {
    try {
      final fileInfo = await mediaCache.getFileFromCache(url);
      if (fileInfo == null) {
        LoggingService.d('DiskCachingService: Downloading to cache -> $url');
        await mediaCache.downloadFile(url);
      } else {
        LoggingService.d('DiskCachingService: Already in cache -> $url');
      }
    } catch (e, stack) {
      // Non-fatal, just log and continue
      LoggingService.w('DiskCachingService: Failed to pre-warm $url', e, stack);
    }
  }

  /// Clears the entire cache. Should be tied to the Parental Dashboard settings.
  static Future<void> clearAllCaches() async {
    try {
      await instance.emptyCache();
      await mediaCache.emptyCache();
      LoggingService.i('DiskCachingService: All caches cleared successfully.');
    } catch (e, stack) {
      LoggingService.e('DiskCachingService: Failed to clear caches', e, stack);
    }
  }
}
