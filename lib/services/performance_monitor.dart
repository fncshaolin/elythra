import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'logger_service.dart';

class PerformanceMonitor extends GetxService {
  static PerformanceMonitor? _instance;
  static PerformanceMonitor get instance => _instance ??= PerformanceMonitor._();
  
  PerformanceMonitor._();

  final Map<String, PerformanceMetric> _metrics = {};
  final Map<String, Stopwatch> _activeTimers = {};
  Timer? _reportingTimer;

  @override
  void onInit() {
    super.onInit();
    _startPerformanceReporting();
    logInfo('Performance Monitor initialized', tag: 'PerformanceMonitor');
  }

  /// Start timing an operation
  void startTimer(String operationName) {
    final stopwatch = Stopwatch()..start();
    _activeTimers[operationName] = stopwatch;
    logDebug('Started timer for: $operationName', tag: 'PerformanceMonitor');
  }

  /// Stop timing an operation and record the metric
  void stopTimer(String operationName, {Map<String, dynamic>? metadata}) {
    final stopwatch = _activeTimers.remove(operationName);
    if (stopwatch == null) {
      logWarning('No active timer found for: $operationName', tag: 'PerformanceMonitor');
      return;
    }

    stopwatch.stop();
    final duration = stopwatch.elapsedMilliseconds;
    
    recordMetric(operationName, duration.toDouble(), metadata: metadata);
    logDebug('Stopped timer for: $operationName (${duration}ms)', tag: 'PerformanceMonitor');
  }

  /// Record a performance metric
  void recordMetric(String name, double value, {Map<String, dynamic>? metadata}) {
    final metric = _metrics[name] ?? PerformanceMetric(name);
    metric.addValue(value, metadata: metadata);
    _metrics[name] = metric;
  }

  /// Record memory usage
  void recordMemoryUsage(String context) {
    if (!kIsWeb) {
      try {
        // This is a simplified memory tracking
        // In a real implementation, you'd use platform-specific APIs
        final timestamp = DateTime.now();
        recordMetric('memory_usage_$context', 0.0, metadata: {
          'timestamp': timestamp.toIso8601String(),
          'context': context,
        });
      } catch (e) {
        logWarning('Failed to record memory usage: $e', tag: 'PerformanceMonitor');
      }
    }
  }

  /// Record network request performance
  void recordNetworkRequest(String endpoint, int statusCode, int durationMs, int responseSize) {
    recordMetric('network_request_duration', durationMs.toDouble(), metadata: {
      'endpoint': endpoint,
      'status_code': statusCode,
      'response_size': responseSize,
      'timestamp': DateTime.now().toIso8601String(),
    });

    recordMetric('network_response_size', responseSize.toDouble(), metadata: {
      'endpoint': endpoint,
    });
  }

  /// Record audio streaming performance
  void recordAudioStreamingMetric(String metricType, double value, {String? quality}) {
    recordMetric('audio_streaming_$metricType', value, metadata: {
      'quality': quality,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Get performance summary
  Map<String, dynamic> getPerformanceSummary() {
    final summary = <String, dynamic>{};
    
    for (final metric in _metrics.values) {
      summary[metric.name] = {
        'count': metric.count,
        'average': metric.average,
        'min': metric.min,
        'max': metric.max,
        'total': metric.total,
        'last_recorded': metric.lastRecorded?.toIso8601String(),
      };
    }

    return summary;
  }

  /// Get metrics for a specific operation
  PerformanceMetric? getMetric(String name) {
    return _metrics[name];
  }

  /// Clear all metrics
  void clearMetrics() {
    _metrics.clear();
    logInfo('Cleared all performance metrics', tag: 'PerformanceMonitor');
  }

  /// Clear metrics older than specified duration
  void clearOldMetrics(Duration maxAge) {
    final cutoff = DateTime.now().subtract(maxAge);
    final keysToRemove = <String>[];

    for (final entry in _metrics.entries) {
      if (entry.value.lastRecorded != null && 
          entry.value.lastRecorded!.isBefore(cutoff)) {
        keysToRemove.add(entry.key);
      }
    }

    for (final key in keysToRemove) {
      _metrics.remove(key);
    }

    if (keysToRemove.isNotEmpty) {
      logInfo('Cleared ${keysToRemove.length} old metrics', tag: 'PerformanceMonitor');
    }
  }

  /// Start automatic performance reporting
  void _startPerformanceReporting() {
    _reportingTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      if (kDebugMode) {
        _logPerformanceSummary();
      }
      
      // Clear old metrics to prevent memory buildup
      clearOldMetrics(const Duration(hours: 1));
    });
  }

  void _logPerformanceSummary() {
    if (_metrics.isEmpty) return;

    final summary = getPerformanceSummary();
    logInfo('Performance Summary: ${summary.length} metrics tracked', tag: 'PerformanceMonitor');
    
    // Log top 5 slowest operations
    final sortedMetrics = _metrics.values.toList()
      ..sort((a, b) => b.average.compareTo(a.average));
    
    for (int i = 0; i < 5 && i < sortedMetrics.length; i++) {
      final metric = sortedMetrics[i];
      logDebug('${metric.name}: avg=${metric.average.toStringAsFixed(2)}ms, '
               'count=${metric.count}, max=${metric.max.toStringAsFixed(2)}ms', 
               tag: 'PerformanceMonitor');
    }
  }

  @override
  void onClose() {
    _reportingTimer?.cancel();
    _activeTimers.clear();
    logInfo('Performance Monitor disposed', tag: 'PerformanceMonitor');
    super.onClose();
  }
}

class PerformanceMetric {
  final String name;
  final List<double> _values = [];
  final List<Map<String, dynamic>?> _metadata = [];
  DateTime? lastRecorded;

  PerformanceMetric(this.name);

  void addValue(double value, {Map<String, dynamic>? metadata}) {
    _values.add(value);
    _metadata.add(metadata);
    lastRecorded = DateTime.now();
    
    // Keep only last 100 values to prevent memory buildup
    if (_values.length > 100) {
      _values.removeAt(0);
      _metadata.removeAt(0);
    }
  }

  int get count => _values.length;
  
  double get average => _values.isEmpty ? 0.0 : _values.reduce((a, b) => a + b) / _values.length;
  
  double get min => _values.isEmpty ? 0.0 : _values.reduce((a, b) => a < b ? a : b);
  
  double get max => _values.isEmpty ? 0.0 : _values.reduce((a, b) => a > b ? a : b);
  
  double get total => _values.isEmpty ? 0.0 : _values.reduce((a, b) => a + b);

  List<double> get values => List.unmodifiable(_values);
  
  List<Map<String, dynamic>?> get metadata => List.unmodifiable(_metadata);
}

// Global convenience functions
void startPerformanceTimer(String operationName) {
  PerformanceMonitor.instance.startTimer(operationName);
}

void stopPerformanceTimer(String operationName, {Map<String, dynamic>? metadata}) {
  PerformanceMonitor.instance.stopTimer(operationName, metadata: metadata);
}

void recordPerformanceMetric(String name, double value, {Map<String, dynamic>? metadata}) {
  PerformanceMonitor.instance.recordMetric(name, value, metadata: metadata);
}

void recordMemoryUsage(String context) {
  PerformanceMonitor.instance.recordMemoryUsage(context);
}

void recordNetworkRequest(String endpoint, int statusCode, int durationMs, int responseSize) {
  PerformanceMonitor.instance.recordNetworkRequest(endpoint, statusCode, durationMs, responseSize);
}

// Wrapper for timing async operations
Future<T> timeAsyncOperation<T>(String operationName, Future<T> Function() operation) async {
  startPerformanceTimer(operationName);
  try {
    final result = await operation();
    stopPerformanceTimer(operationName, metadata: {'success': true});
    return result;
  } catch (e) {
    stopPerformanceTimer(operationName, metadata: {'success': false, 'error': e.toString()});
    rethrow;
  }
}

// Wrapper for timing sync operations
T timeSyncOperation<T>(String operationName, T Function() operation) {
  startPerformanceTimer(operationName);
  try {
    final result = operation();
    stopPerformanceTimer(operationName, metadata: {'success': true});
    return result;
  } catch (e) {
    stopPerformanceTimer(operationName, metadata: {'success': false, 'error': e.toString()});
    rethrow;
  }
}