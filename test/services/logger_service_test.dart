import 'package:flutter_test/flutter_test.dart';
import 'package:elythra/services/logger_service.dart';

void main() {
  group('LoggerService Tests', () {
    late LoggerService logger;

    setUp(() {
      logger = LoggerService.instance;
    });

    test('Logger initializes correctly', () async {
      await logger.initialize();
      expect(logger, isNotNull);
    });

    test('Log levels work correctly', () {
      // These should not throw exceptions
      expect(() => logger.debug('Debug message'), returnsNormally);
      expect(() => logger.info('Info message'), returnsNormally);
      expect(() => logger.warning('Warning message'), returnsNormally);
      expect(() => logger.error('Error message'), returnsNormally);
      expect(() => logger.critical('Critical message'), returnsNormally);
    });

    test('Global logging functions work', () {
      expect(() => logDebug('Debug test'), returnsNormally);
      expect(() => logInfo('Info test'), returnsNormally);
      expect(() => logWarning('Warning test'), returnsNormally);
      expect(() => logError('Error test'), returnsNormally);
      expect(() => logCritical('Critical test'), returnsNormally);
    });
  });
}