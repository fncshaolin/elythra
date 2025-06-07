import 'package:flutter_test/flutter_test.dart';
import 'package:elythra/services/error_handler.dart';
import 'package:dio/dio.dart';
import 'dart:io';

void main() {
  group('ErrorHandler Tests', () {
    late ErrorHandler errorHandler;

    setUp(() {
      errorHandler = ErrorHandler.instance;
    });

    test('Custom exceptions are created correctly', () {
      const networkError = NetworkException('Network failed', code: 'NET_001');
      expect(networkError.message, equals('Network failed'));
      expect(networkError.code, equals('NET_001'));

      const audioError = AudioException('Audio failed');
      expect(audioError.message, equals('Audio failed'));

      const parseError = ParseException('Parse failed');
      expect(parseError.message, equals('Parse failed'));

      const storageError = StorageException('Storage failed');
      expect(storageError.message, equals('Storage failed'));
    });

    test('safeExecute handles exceptions correctly', () async {
      // Test successful execution
      final result = await safeExecute<String>(
        () async => 'success',
        fallback: 'fallback',
      );
      expect(result, equals('success'));

      // Test exception handling
      final failResult = await safeExecute<String>(
        () async => throw Exception('test error'),
        fallback: 'fallback',
        showToUser: false,
      );
      expect(failResult, equals('fallback'));
    });

    test('safeExecuteSync handles exceptions correctly', () {
      // Test successful execution
      final result = safeExecuteSync<String>(
        () => 'success',
        fallback: 'fallback',
      );
      expect(result, equals('success'));

      // Test exception handling
      final failResult = safeExecuteSync<String>(
        () => throw Exception('test error'),
        fallback: 'fallback',
        showToUser: false,
      );
      expect(failResult, equals('fallback'));
    });

    test('Error analysis works for different error types', () {
      // Test with different error types
      expect(() => errorHandler.handleError(
        const SocketException('Connection failed'),
        showToUser: false,
      ), returnsNormally);

      expect(() => errorHandler.handleError(
        DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.connectionTimeout,
        ),
        showToUser: false,
      ), returnsNormally);

      expect(() => errorHandler.handleError(
        const FormatException('Invalid format'),
        showToUser: false,
      ), returnsNormally);
    });
  });
}