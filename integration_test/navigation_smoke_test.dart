import 'package:copia/main.dart' as app;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('library navigation to stats/settings/quotes works', (
    tester,
  ) async {
    app.main();
    await tester.pumpAndSettle();

    final skip = find.byKey(const Key('onboarding_skip_button'));
    if (skip.evaluate().isNotEmpty) {
      await tester.tap(skip);
      await tester.pumpAndSettle();
    }

    expect(find.text('Copia Library'), findsOneWidget);

    await tester.tap(find.byKey(const Key('library_stats_button')));
    await tester.pumpAndSettle();
    expect(find.text('Reading Stats'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('library_settings_button')));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('library_quotes_button')));
    await tester.pumpAndSettle();
    expect(find.text('Quote Maker'), findsOneWidget);
  });
}
