// Student Manager App Widget Tests
//
// This file contains widget tests for the Student Manager application.
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:studentapp/main.dart';

void main() {
  group('Student Manager App Tests', () {
    testWidgets('App should start with home screen', (
      WidgetTester tester,
    ) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const StudentManagerApp());

      // Verify that the app starts with the home screen
      expect(find.text('Student Manager'), findsOneWidget);
      expect(find.text('Chào mừng đến với Student Manager'), findsOneWidget);

      // Verify that at least some navigation buttons are present
      expect(find.text('Sinh viên'), findsOneWidget);
      expect(find.text('Môn học'), findsOneWidget);
    });

    testWidgets('Navigation should work between screens', (
      WidgetTester tester,
    ) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const StudentManagerApp());

      // Navigate to Students screen
      await tester.tap(find.text('Sinh viên'));
      await tester.pumpAndSettle();

      // Verify we're on the Students screen
      expect(find.text('Sinh viên'), findsOneWidget);

      // Navigate back to home
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Verify we're back on the home screen
      expect(find.text('Student Manager'), findsOneWidget);
    });

    testWidgets('Student screen should show content', (
      WidgetTester tester,
    ) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const StudentManagerApp());

      // Navigate to Students screen
      await tester.tap(find.text('Sinh viên'));
      await tester.pumpAndSettle();

      // Should show the students screen
      expect(find.text('Sinh viên'), findsOneWidget);
    });

    testWidgets('App should have correct title', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const StudentManagerApp());

      // Find the MaterialApp widget
      final MaterialApp app = tester.widget(find.byType(MaterialApp));

      // Verify app title
      expect(app.title, equals('Student Manager'));
    });

    testWidgets('Home screen should have navigation cards', (
      WidgetTester tester,
    ) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const StudentManagerApp());

      // Verify some navigation cards are present
      expect(find.byType(InkWell), findsWidgets);
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('Theme should be applied', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const StudentManagerApp());

      // Find the MaterialApp widget
      final MaterialApp app = tester.widget(find.byType(MaterialApp));

      // Verify theme is applied
      expect(app.theme, isNotNull);
    });
  });
}
