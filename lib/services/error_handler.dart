import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'logger_service.dart';
import '../ui/widgets/snackbar.dart';

// Custom exception classes
class ElytraException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const ElytraException(
    this.message, {
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => 'ElytraException: $message${code != null ? ' (Code: $code)' : ''}';
}

class NetworkException extends ElytraException {
  const NetworkException(String message, {String? code, dynamic originalError, StackTrace? stackTrace})
      : super(message, code: code, originalError: originalError, stackTrace: stackTrace);
}

class AudioException extends ElytraException {
  const AudioException(String message, {String? code, dynamic originalError, StackTrace? stackTrace})
      : super(message, code: code, originalError: originalError, stackTrace: stackTrace);
}

class ParseException extends ElytraException {
  const ParseException(String message, {String? code, dynamic originalError, StackTrace? stackTrace})
      : super(message, code: code, originalError: originalError, stackTrace: stackTrace);
}

class StorageException extends ElytraException {
  const StorageException(String message, {String? code, dynamic originalError, StackTrace? stackTrace})
      : super(message, code: code, originalError: originalError, stackTrace: stackTrace);
}

class ErrorHandler {
  static ErrorHandler? _instance;
  static ErrorHandler get instance => _instance ??= ErrorHandler._();
  
  ErrorHandler._();

  /// Handle and log errors with appropriate user feedback
  void handleError(
    dynamic error, {
    String? context,
    bool showToUser = true,
    StackTrace? stackTrace,
  }) {
    final errorInfo = _analyzeError(error);
    
    // Log the error
    logError(
      '${context != null ? '[$context] ' : ''}${errorInfo.message}',
      tag: 'ErrorHandler',
      error: error,
      stackTrace: stackTrace ?? StackTrace.current,
    );

    // Show user-friendly message if requested
    if (showToUser && Get.context != null) {
      _showUserMessage(errorInfo);
    }
  }

  /// Analyze error and return user-friendly information
  ErrorInfo _analyzeError(dynamic error) {
    if (error is ElytraException) {
      return ErrorInfo(
        message: error.message,
        userMessage: _getLocalizedMessage(error),
        severity: ErrorSeverity.medium,
      );
    }

    if (error is DioException) {
      return _handleDioError(error);
    }

    if (error is SocketException) {
      return ErrorInfo(
        message: 'Network connection failed: ${error.message}',
        userMessage: 'networkError'.tr,
        severity: ErrorSeverity.medium,
      );
    }

    if (error is TimeoutException) {
      return ErrorInfo(
        message: 'Operation timed out: ${error.message}',
        userMessage: 'timeoutError'.tr,
        severity: ErrorSeverity.medium,
      );
    }

    if (error is FormatException) {
      return ErrorInfo(
        message: 'Data format error: ${error.message}',
        userMessage: 'dataFormatError'.tr,
        severity: ErrorSeverity.low,
      );
    }

    if (error is FileSystemException) {
      return ErrorInfo(
        message: 'File system error: ${error.message}',
        userMessage: 'fileSystemError'.tr,
        severity: ErrorSeverity.medium,
      );
    }

    // Generic error
    return ErrorInfo(
      message: 'Unexpected error: ${error.toString()}',
      userMessage: 'unexpectedError'.tr,
      severity: ErrorSeverity.high,
    );
  }

  ErrorInfo _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ErrorInfo(
          message: 'Network timeout: ${error.message}',
          userMessage: 'networkTimeout'.tr,
          severity: ErrorSeverity.medium,
        );
      
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        return ErrorInfo(
          message: 'HTTP error $statusCode: ${error.message}',
          userMessage: statusCode == 429 ? 'rateLimitError'.tr : 'serverError'.tr,
          severity: ErrorSeverity.medium,
        );
      
      case DioExceptionType.cancel:
        return ErrorInfo(
          message: 'Request cancelled',
          userMessage: 'requestCancelled'.tr,
          severity: ErrorSeverity.low,
        );
      
      case DioExceptionType.connectionError:
        return ErrorInfo(
          message: 'Connection error: ${error.message}',
          userMessage: 'connectionError'.tr,
          severity: ErrorSeverity.medium,
        );
      
      default:
        return ErrorInfo(
          message: 'Network error: ${error.message}',
          userMessage: 'networkError'.tr,
          severity: ErrorSeverity.medium,
        );
    }
  }

  String _getLocalizedMessage(ElytraException error) {
    // Map error codes to localized messages
    switch (error.code) {
      case 'AUDIO_STREAM_NOT_FOUND':
        return 'audioStreamNotFound'.tr;
      case 'PLAYLIST_NOT_FOUND':
        return 'playlistNotFound'.tr;
      case 'INVALID_AUDIO_FORMAT':
        return 'invalidAudioFormat'.tr;
      case 'STORAGE_FULL':
        return 'storageFull'.tr;
      case 'PERMISSION_DENIED':
        return 'permissionDenied'.tr;
      default:
        return error.message;
    }
  }

  void _showUserMessage(ErrorInfo errorInfo) {
    final color = switch (errorInfo.severity) {
      ErrorSeverity.low => Colors.orange,
      ErrorSeverity.medium => Colors.red,
      ErrorSeverity.high => Colors.red.shade800,
    };

    showCustomSnackBar(
      Get.context!,
      errorInfo.userMessage,
      color: color,
    );
  }

  /// Wrapper for async operations with error handling
  static Future<T?> safeExecute<T>(
    Future<T> Function() operation, {
    String? context,
    bool showToUser = true,
    T? fallback,
  }) async {
    try {
      return await operation();
    } catch (error, stackTrace) {
      ErrorHandler.instance.handleError(
        error,
        context: context,
        showToUser: showToUser,
        stackTrace: stackTrace,
      );
      return fallback;
    }
  }

  /// Wrapper for sync operations with error handling
  static T? safeExecuteSync<T>(
    T Function() operation, {
    String? context,
    bool showToUser = true,
    T? fallback,
  }) {
    try {
      return operation();
    } catch (error, stackTrace) {
      ErrorHandler.instance.handleError(
        error,
        context: context,
        showToUser: showToUser,
        stackTrace: stackTrace,
      );
      return fallback;
    }
  }
}

class ErrorInfo {
  final String message;
  final String userMessage;
  final ErrorSeverity severity;

  const ErrorInfo({
    required this.message,
    required this.userMessage,
    required this.severity,
  });
}

enum ErrorSeverity { low, medium, high }

// Global convenience functions
void handleError(dynamic error, {String? context, bool showToUser = true, StackTrace? stackTrace}) {
  ErrorHandler.instance.handleError(error, context: context, showToUser: showToUser, stackTrace: stackTrace);
}

Future<T?> safeExecute<T>(
  Future<T> Function() operation, {
  String? context,
  bool showToUser = true,
  T? fallback,
}) {
  return ErrorHandler.safeExecute(operation, context: context, showToUser: showToUser, fallback: fallback);
}

T? safeExecuteSync<T>(
  T Function() operation, {
  String? context,
  bool showToUser = true,
  T? fallback,
}) {
  return ErrorHandler.safeExecuteSync(operation, context: context, showToUser: showToUser, fallback: fallback);
}