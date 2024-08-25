import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('test if loader ', () {
    testWidgets("is displayed once", (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Loader(),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      expect(find.byType(Center), findsOneWidget);

      expect(find.byType(Text), findsNothing);
    });
  });
}
