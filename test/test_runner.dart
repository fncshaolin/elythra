import 'package:flutter_test/flutter_test.dart';

// Import all test files
import 'widget_test.dart' as widget_tests;
import 'services/logger_service_test.dart' as logger_tests;
import 'services/error_handler_test.dart' as error_handler_tests;
import 'services/youtube_audio_extractor_test.dart' as youtube_extractor_tests;

void main() {
  group('Elythra Test Suite', () {
    group('Widget Tests', widget_tests.main);
    group('Logger Service Tests', logger_tests.main);
    group('Error Handler Tests', error_handler_tests.main);
    group('YouTube Audio Extractor Tests', youtube_extractor_tests.main);
  });
}