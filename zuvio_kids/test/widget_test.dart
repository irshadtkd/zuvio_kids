import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zuvio_kids/main.dart';

void main() {
  testWidgets('ZuvioKidsApp renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: ZuvioKidsApp()),
    );
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
