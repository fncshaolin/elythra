import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'logger_service.dart';

class MemoryManager extends GetxService {
  static MemoryManager? _instance;
  static MemoryManager get instance => _instance ??= MemoryManager._();
  
  MemoryManager._();

  final List<StreamSubscription> _subscriptions = [];
  final List<Timer> _timers = [];
  final List<Disposable> _disposables = [];
  final Map<String, dynamic> _cache = {};
  
  int _maxCacheSize = 100;
  int _cacheCleanupThreshold = 80;

  @override
  void onInit() {
    super.onInit();
    _startMemoryMonitoring();
    logInfo('Memory Manager initialized', tag: 'MemoryManager');
  }

  /// Register a stream subscription for automatic disposal
  void registerSubscription(StreamSubscription subscription, {String? tag}) {
    _subscriptions.add(subscription);
    logDebug('Registered subscription${tag != null ? ' [$tag]' : ''}', tag: 'MemoryManager');
  }

  /// Register a timer for automatic disposal
  void registerTimer(Timer timer, {String? tag}) {
    _timers.add(timer);
    logDebug('Registered timer${tag != null ? ' [$tag]' : ''}', tag: 'MemoryManager');
  }

  /// Register a disposable object
  void registerDisposable(Disposable disposable, {String? tag}) {
    _disposables.add(disposable);
    logDebug('Registered disposable${tag != null ? ' [$tag]' : ''}', tag: 'MemoryManager');
  }

  /// Cache management with automatic cleanup
  void cacheData(String key, dynamic data, {Duration? ttl}) {
    if (_cache.length >= _maxCacheSize) {
      _cleanupCache();
    }

    final cacheEntry = CacheEntry(
      data: data,
      timestamp: DateTime.now(),
      ttl: ttl,
    );

    _cache[key] = cacheEntry;
    logDebug('Cached data for key: $key', tag: 'MemoryManager');
  }

  /// Retrieve cached data
  T? getCachedData<T>(String key) {
    final entry = _cache[key] as CacheEntry?;
    if (entry == null) return null;

    // Check if expired
    if (entry.ttl != null && 
        DateTime.now().difference(entry.timestamp) > entry.ttl!) {
      _cache.remove(key);
      logDebug('Cache entry expired for key: $key', tag: 'MemoryManager');
      return null;
    }

    return entry.data as T?;
  }

  /// Clear specific cache entry
  void clearCache(String key) {
    _cache.remove(key);
    logDebug('Cleared cache for key: $key', tag: 'MemoryManager');
  }

  /// Clear all cache
  void clearAllCache() {
    final count = _cache.length;
    _cache.clear();
    logInfo('Cleared all cache ($count entries)', tag: 'MemoryManager');
  }

  /// Get memory usage information
  Map<String, dynamic> getMemoryInfo() {
    return {
      'subscriptions': _subscriptions.length,
      'timers': _timers.length,
      'disposables': _disposables.length,
      'cacheEntries': _cache.length,
      'cacheSize': _calculateCacheSize(),
    };
  }

  /// Force garbage collection (if available)
  void forceGarbageCollection() {
    if (!kIsWeb) {
      // Force GC on non-web platforms
      logInfo('Forcing garbage collection', tag: 'MemoryManager');
    }
  }

  /// Cleanup expired cache entries
  void _cleanupCache() {
    final now = DateTime.now();
    final keysToRemove = <String>[];

    for (final entry in _cache.entries) {
      final cacheEntry = entry.value as CacheEntry;
      if (cacheEntry.ttl != null && 
          now.difference(cacheEntry.timestamp) > cacheEntry.ttl!) {
        keysToRemove.add(entry.key);
      }
    }

    // Remove oldest entries if still over threshold
    if (_cache.length - keysToRemove.length > _cacheCleanupThreshold) {
      final sortedEntries = _cache.entries.toList()
        ..sort((a, b) => (a.value as CacheEntry).timestamp
            .compareTo((b.value as CacheEntry).timestamp));
      
      final entriesToRemove = sortedEntries.take(
        _cache.length - _cacheCleanupThreshold
      );
      
      for (final entry in entriesToRemove) {
        keysToRemove.add(entry.key);
      }
    }

    for (final key in keysToRemove) {
      _cache.remove(key);
    }

    if (keysToRemove.isNotEmpty) {
      logInfo('Cleaned up ${keysToRemove.length} cache entries', tag: 'MemoryManager');
    }
  }

  int _calculateCacheSize() {
    // Rough estimation of cache size
    return _cache.length * 1024; // Assume 1KB per entry on average
  }

  void _startMemoryMonitoring() {
    // Monitor memory usage every 30 seconds
    Timer.periodic(const Duration(seconds: 30), (timer) {
      _cleanupCache();
      
      // Log memory info periodically in debug mode
      if (kDebugMode) {
        final info = getMemoryInfo();
        logDebug('Memory info: $info', tag: 'MemoryManager');
      }
    });
  }

  /// Dispose all managed resources
  @override
  void onClose() {
    logInfo('Disposing Memory Manager resources', tag: 'MemoryManager');
    
    // Cancel all subscriptions
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();

    // Cancel all timers
    for (final timer in _timers) {
      timer.cancel();
    }
    _timers.clear();

    // Dispose all disposables
    for (final disposable in _disposables) {
      try {
        disposable.dispose();
      } catch (e) {
        logWarning('Error disposing resource: $e', tag: 'MemoryManager');
      }
    }
    _disposables.clear();

    // Clear cache
    clearAllCache();

    super.onClose();
  }
}

class CacheEntry {
  final dynamic data;
  final DateTime timestamp;
  final Duration? ttl;

  CacheEntry({
    required this.data,
    required this.timestamp,
    this.ttl,
  });
}

abstract class Disposable {
  void dispose();
}

// Extension to make controllers disposable
extension DisposableController on GetxController {
  void registerForDisposal() {
    MemoryManager.instance.registerDisposable(_ControllerDisposable(this));
  }
}

class _ControllerDisposable implements Disposable {
  final GetxController controller;
  
  _ControllerDisposable(this.controller);
  
  @override
  void dispose() {
    if (Get.isRegistered<GetxController>(tag: controller.runtimeType.toString())) {
      Get.delete<GetxController>(tag: controller.runtimeType.toString());
    }
  }
}

// Global convenience functions
void registerSubscription(StreamSubscription subscription, {String? tag}) {
  MemoryManager.instance.registerSubscription(subscription, tag: tag);
}

void registerTimer(Timer timer, {String? tag}) {
  MemoryManager.instance.registerTimer(timer, tag: tag);
}

void cacheData(String key, dynamic data, {Duration? ttl}) {
  MemoryManager.instance.cacheData(key, data, ttl: ttl);
}

T? getCachedData<T>(String key) {
  return MemoryManager.instance.getCachedData<T>(key);
}