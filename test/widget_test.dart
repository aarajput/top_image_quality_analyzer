// Basic Flutter widget test for Best Image Selector app

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:best_image_selector/main.dart';

void main() {
  testWidgets('App initializes and shows loading screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BestImageSelectorApp());

    // Verify that loading screen is shown initially
    expect(find.text('Loading AI models...'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('App title is correct', (WidgetTester tester) async {
    // Build our app
    await tester.pumpWidget(const BestImageSelectorApp());

    // Verify app title
    final MaterialApp app = tester.widget(find.byType(MaterialApp));
    expect(app.title, 'Best Image Selector');
  });
}
