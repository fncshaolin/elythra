import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:elythra/main.dart';
import 'package:elythra/services/logger_service.dart';

void main() {
  group('Elythra Music App Tests', () {
    setUpAll(() async {
      // Initialize test environment
      await Hive.initFlutter();
      await LoggerService.instance.initialize();
    });

    tearDownAll(() async {
      // Clean up after tests
      await Hive.close();
    });

    testWidgets('App initializes without crashing', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify that the app loads
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Navigation bar is present', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Look for navigation elements
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });
  });
}
