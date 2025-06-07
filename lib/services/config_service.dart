import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'logger_service.dart';
import 'music_service.dart';

class ConfigService extends GetxService {
  static ConfigService? _instance;
  static ConfigService get instance => _instance ??= ConfigService._();
  
  ConfigService._();

  late Box _configBox;
  bool _initialized = false;

  // Configuration keys
  static const String _streamingQualityKey = 'streaming_quality';
  static const String _downloadQualityKey = 'download_quality';
  static const String _cacheEnabledKey = 'cache_enabled';
  static const String _maxCacheSizeKey = 'max_cache_size_mb';
  static const String _autoCleanupKey = 'auto_cleanup_enabled';
  static const String _logLevelKey = 'log_level';
  static const String _performanceMonitoringKey = 'performance_monitoring';
  static const String _networkTimeoutKey = 'network_timeout_seconds';
  static const String _maxConcurrentDownloadsKey = 'max_concurrent_downloads';
  static const String _preferYouTubeOverYTMusicKey = 'prefer_youtube_over_ytmusic';

  // Default values
  static const AudioQuality _defaultStreamingQuality = AudioQuality.Medium;
  static const AudioQuality _defaultDownloadQuality = AudioQuality.High;
  static const bool _defaultCacheEnabled = true;
  static const int _defaultMaxCacheSizeMB = 500;
  static const bool _defaultAutoCleanup = true;
  static const String _defaultLogLevel = 'info';
  static const bool _defaultPerformanceMonitoring = true;
  static const int _defaultNetworkTimeout = 30;
  static const int _defaultMaxConcurrentDownloads = 3;
  static const bool _defaultPreferYouTubeOverYTMusic = false;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeConfig();
  }

  Future<void> _initializeConfig() async {
    try {
      _configBox = await Hive.openBox('elythra_config');
      _initialized = true;
      
      // Set default values if not already set
      await _setDefaultsIfNeeded();
      
      logInfo('Configuration service initialized', tag: 'ConfigService');
    } catch (e) {
      logError('Failed to initialize configuration service', 
               tag: 'ConfigService', error: e);
    }
  }

  Future<void> _setDefaultsIfNeeded() async {
    final defaults = {
      _streamingQualityKey: AudioQuality.values.indexOf(_defaultStreamingQuality),
      _downloadQualityKey: AudioQuality.values.indexOf(_defaultDownloadQuality),
      _cacheEnabledKey: _defaultCacheEnabled,
      _maxCacheSizeKey: _defaultMaxCacheSizeMB,
      _autoCleanupKey: _defaultAutoCleanup,
      _logLevelKey: _defaultLogLevel,
      _performanceMonitoringKey: _defaultPerformanceMonitoring,
      _networkTimeoutKey: _defaultNetworkTimeout,
      _maxConcurrentDownloadsKey: _defaultMaxConcurrentDownloads,
      _preferYouTubeOverYTMusicKey: _defaultPreferYouTubeOverYTMusic,
    };

    for (final entry in defaults.entries) {
      if (!_configBox.containsKey(entry.key)) {
        await _configBox.put(entry.key, entry.value);
      }
    }
  }

  // Streaming Quality
  AudioQuality get streamingQuality {
    if (!_initialized) return _defaultStreamingQuality;
    final index = _configBox.get(_streamingQualityKey, defaultValue: AudioQuality.values.indexOf(_defaultStreamingQuality));
    return AudioQuality.values[index];
  }

  Future<void> setStreamingQuality(AudioQuality quality) async {
    if (!_initialized) return;
    await _configBox.put(_streamingQualityKey, AudioQuality.values.indexOf(quality));
    logInfo('Streaming quality set to: ${quality.displayName}', tag: 'ConfigService');
  }

  // Download Quality
  AudioQuality get downloadQuality {
    if (!_initialized) return _defaultDownloadQuality;
    final index = _configBox.get(_downloadQualityKey, defaultValue: AudioQuality.values.indexOf(_defaultDownloadQuality));
    return AudioQuality.values[index];
  }

  Future<void> setDownloadQuality(AudioQuality quality) async {
    if (!_initialized) return;
    await _configBox.put(_downloadQualityKey, AudioQuality.values.indexOf(quality));
    logInfo('Download quality set to: ${quality.displayName}', tag: 'ConfigService');
  }

  // Cache Settings
  bool get cacheEnabled {
    if (!_initialized) return _defaultCacheEnabled;
    return _configBox.get(_cacheEnabledKey, defaultValue: _defaultCacheEnabled);
  }

  Future<void> setCacheEnabled(bool enabled) async {
    if (!_initialized) return;
    await _configBox.put(_cacheEnabledKey, enabled);
    logInfo('Cache ${enabled ? 'enabled' : 'disabled'}', tag: 'ConfigService');
  }

  int get maxCacheSizeMB {
    if (!_initialized) return _defaultMaxCacheSizeMB;
    return _configBox.get(_maxCacheSizeKey, defaultValue: _defaultMaxCacheSizeMB);
  }

  Future<void> setMaxCacheSizeMB(int sizeMB) async {
    if (!_initialized) return;
    await _configBox.put(_maxCacheSizeKey, sizeMB);
    logInfo('Max cache size set to: ${sizeMB}MB', tag: 'ConfigService');
  }

  bool get autoCleanupEnabled {
    if (!_initialized) return _defaultAutoCleanup;
    return _configBox.get(_autoCleanupKey, defaultValue: _defaultAutoCleanup);
  }

  Future<void> setAutoCleanupEnabled(bool enabled) async {
    if (!_initialized) return;
    await _configBox.put(_autoCleanupKey, enabled);
    logInfo('Auto cleanup ${enabled ? 'enabled' : 'disabled'}', tag: 'ConfigService');
  }

  // Logging Settings
  String get logLevel {
    if (!_initialized) return _defaultLogLevel;
    return _configBox.get(_logLevelKey, defaultValue: _defaultLogLevel);
  }

  Future<void> setLogLevel(String level) async {
    if (!_initialized) return;
    await _configBox.put(_logLevelKey, level);
    logInfo('Log level set to: $level', tag: 'ConfigService');
  }

  // Performance Monitoring
  bool get performanceMonitoringEnabled {
    if (!_initialized) return _defaultPerformanceMonitoring;
    return _configBox.get(_performanceMonitoringKey, defaultValue: _defaultPerformanceMonitoring);
  }

  Future<void> setPerformanceMonitoringEnabled(bool enabled) async {
    if (!_initialized) return;
    await _configBox.put(_performanceMonitoringKey, enabled);
    logInfo('Performance monitoring ${enabled ? 'enabled' : 'disabled'}', tag: 'ConfigService');
  }

  // Network Settings
  int get networkTimeoutSeconds {
    if (!_initialized) return _defaultNetworkTimeout;
    return _configBox.get(_networkTimeoutKey, defaultValue: _defaultNetworkTimeout);
  }

  Future<void> setNetworkTimeoutSeconds(int seconds) async {
    if (!_initialized) return;
    await _configBox.put(_networkTimeoutKey, seconds);
    logInfo('Network timeout set to: ${seconds}s', tag: 'ConfigService');
  }

  int get maxConcurrentDownloads {
    if (!_initialized) return _defaultMaxConcurrentDownloads;
    return _configBox.get(_maxConcurrentDownloadsKey, defaultValue: _defaultMaxConcurrentDownloads);
  }

  Future<void> setMaxConcurrentDownloads(int count) async {
    if (!_initialized) return;
    await _configBox.put(_maxConcurrentDownloadsKey, count);
    logInfo('Max concurrent downloads set to: $count', tag: 'ConfigService');
  }

  // YouTube vs YouTube Music preference
  bool get preferYouTubeOverYTMusic {
    if (!_initialized) return _defaultPreferYouTubeOverYTMusic;
    return _configBox.get(_preferYouTubeOverYTMusicKey, defaultValue: _defaultPreferYouTubeOverYTMusic);
  }

  Future<void> setPreferYouTubeOverYTMusic(bool prefer) async {
    if (!_initialized) return;
    await _configBox.put(_preferYouTubeOverYTMusicKey, prefer);
    logInfo('Prefer YouTube over YT Music: $prefer', tag: 'ConfigService');
  }

  // Export/Import Configuration
  Map<String, dynamic> exportConfig() {
    if (!_initialized) return {};
    
    return {
      'streaming_quality': streamingQuality.name,
      'download_quality': downloadQuality.name,
      'cache_enabled': cacheEnabled,
      'max_cache_size_mb': maxCacheSizeMB,
      'auto_cleanup_enabled': autoCleanupEnabled,
      'log_level': logLevel,
      'performance_monitoring_enabled': performanceMonitoringEnabled,
      'network_timeout_seconds': networkTimeoutSeconds,
      'max_concurrent_downloads': maxConcurrentDownloads,
      'prefer_youtube_over_ytmusic': preferYouTubeOverYTMusic,
      'export_timestamp': DateTime.now().toIso8601String(),
      'app_version': '1.0.0', // This should come from package info
    };
  }

  Future<bool> importConfig(Map<String, dynamic> config) async {
    if (!_initialized) return false;

    try {
      // Validate and import configuration
      if (config.containsKey('streaming_quality')) {
        final qualityName = config['streaming_quality'] as String;
        final quality = AudioQuality.values.firstWhere(
          (q) => q.name == qualityName,
          orElse: () => _defaultStreamingQuality,
        );
        await setStreamingQuality(quality);
      }

      if (config.containsKey('download_quality')) {
        final qualityName = config['download_quality'] as String;
        final quality = AudioQuality.values.firstWhere(
          (q) => q.name == qualityName,
          orElse: () => _defaultDownloadQuality,
        );
        await setDownloadQuality(quality);
      }

      if (config.containsKey('cache_enabled')) {
        await setCacheEnabled(config['cache_enabled'] as bool);
      }

      if (config.containsKey('max_cache_size_mb')) {
        await setMaxCacheSizeMB(config['max_cache_size_mb'] as int);
      }

      if (config.containsKey('auto_cleanup_enabled')) {
        await setAutoCleanupEnabled(config['auto_cleanup_enabled'] as bool);
      }

      if (config.containsKey('log_level')) {
        await setLogLevel(config['log_level'] as String);
      }

      if (config.containsKey('performance_monitoring_enabled')) {
        await setPerformanceMonitoringEnabled(config['performance_monitoring_enabled'] as bool);
      }

      if (config.containsKey('network_timeout_seconds')) {
        await setNetworkTimeoutSeconds(config['network_timeout_seconds'] as int);
      }

      if (config.containsKey('max_concurrent_downloads')) {
        await setMaxConcurrentDownloads(config['max_concurrent_downloads'] as int);
      }

      if (config.containsKey('prefer_youtube_over_ytmusic')) {
        await setPreferYouTubeOverYTMusic(config['prefer_youtube_over_ytmusic'] as bool);
      }

      logInfo('Configuration imported successfully', tag: 'ConfigService');
      return true;
    } catch (e) {
      logError('Failed to import configuration', tag: 'ConfigService', error: e);
      return false;
    }
  }

  // Reset to defaults
  Future<void> resetToDefaults() async {
    if (!_initialized) return;

    await _configBox.clear();
    await _setDefaultsIfNeeded();
    logInfo('Configuration reset to defaults', tag: 'ConfigService');
  }

  @override
  void onClose() {
    if (_initialized) {
      _configBox.close();
    }
    super.onClose();
  }
}

// Global convenience functions
ConfigService get config => ConfigService.instance;