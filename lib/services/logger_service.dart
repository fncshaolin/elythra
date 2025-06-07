import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

enum LogLevel { debug, info, warning, error, critical }

class LoggerService {
  static LoggerService? _instance;
  static LoggerService get instance => _instance ??= LoggerService._();
  
  LoggerService._();
  
  File? _logFile;
  bool _initialized = false;
  
  Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      if (!kIsWeb) {
        final directory = await getApplicationDocumentsDirectory();
        final logDir = Directory('${directory.path}/logs');
        if (!await logDir.exists()) {
          await logDir.create(recursive: true);
        }
        
        final now = DateTime.now();
        final fileName = 'elythra_${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}.log';
        _logFile = File('${logDir.path}/$fileName');
      }
      _initialized = true;
    } catch (e) {
      developer.log('Failed to initialize logger: $e', name: 'LoggerService');
    }
  }
  
  void log(LogLevel level, String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    final timestamp = DateTime.now().toIso8601String();
    final levelStr = level.name.toUpperCase();
    final tagStr = tag != null ? '[$tag]' : '';
    final logMessage = '$timestamp [$levelStr] $tagStr $message';
    
    // Console logging
    if (kDebugMode) {
      switch (level) {
        case LogLevel.debug:
          developer.log(logMessage, name: tag ?? 'Elythra');
          break;
        case LogLevel.info:
          developer.log(logMessage, name: tag ?? 'Elythra');
          break;
        case LogLevel.warning:
          developer.log(logMessage, name: tag ?? 'Elythra', level: 900);
          break;
        case LogLevel.error:
        case LogLevel.critical:
          developer.log(logMessage, name: tag ?? 'Elythra', level: 1000, error: error, stackTrace: stackTrace);
          break;
      }
    }
    
    // File logging (non-web platforms)
    if (_logFile != null && _initialized) {
      try {
        final fullMessage = error != null 
            ? '$logMessage\nError: $error${stackTrace != null ? '\nStackTrace: $stackTrace' : ''}'
            : logMessage;
        _logFile!.writeAsStringSync('$fullMessage\n', mode: FileMode.append);
      } catch (e) {
        developer.log('Failed to write to log file: $e', name: 'LoggerService');
      }
    }
  }
  
  void debug(String message, {String? tag}) => log(LogLevel.debug, message, tag: tag);
  void info(String message, {String? tag}) => log(LogLevel.info, message, tag: tag);
  void warning(String message, {String? tag, Object? error}) => log(LogLevel.warning, message, tag: tag, error: error);
  void error(String message, {String? tag, Object? error, StackTrace? stackTrace}) => 
      log(LogLevel.error, message, tag: tag, error: error, stackTrace: stackTrace);
  void critical(String message, {String? tag, Object? error, StackTrace? stackTrace}) => 
      log(LogLevel.critical, message, tag: tag, error: error, stackTrace: stackTrace);
  
  Future<void> clearOldLogs({int daysToKeep = 7}) async {
    if (_logFile == null) return;
    
    try {
      final logDir = _logFile!.parent;
      final files = await logDir.list().toList();
      final cutoffDate = DateTime.now().subtract(Duration(days: daysToKeep));
      
      for (final file in files) {
        if (file is File && file.path.endsWith('.log')) {
          final stat = await file.stat();
          if (stat.modified.isBefore(cutoffDate)) {
            await file.delete();
            debug('Deleted old log file: ${file.path}', tag: 'LoggerService');
          }
        }
      }
    } catch (e) {
      error('Failed to clear old logs: $e', tag: 'LoggerService', error: e);
    }
  }
}

// Global convenience functions
void logDebug(String message, {String? tag}) => LoggerService.instance.debug(message, tag: tag);
void logInfo(String message, {String? tag}) => LoggerService.instance.info(message, tag: tag);
void logWarning(String message, {String? tag, Object? error}) => LoggerService.instance.warning(message, tag: tag, error: error);
void logError(String message, {String? tag, Object? error, StackTrace? stackTrace}) => 
    LoggerService.instance.error(message, tag: tag, error: error, stackTrace: stackTrace);
void logCritical(String message, {String? tag, Object? error, StackTrace? stackTrace}) => 
    LoggerService.instance.critical(message, tag: tag, error: error, stackTrace: stackTrace);