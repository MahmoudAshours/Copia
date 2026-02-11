import 'package:copia/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('app boots into onboarding or library', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Text &&
            (widget.data == 'Copia Library' ||
                widget.data == 'Welcome To Copia 2.0'),
      ),
      findsAtLeastNWidgets(1),
    );

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
