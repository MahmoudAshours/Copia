import 'package:copia/main.dart' as app;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'test_support.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('stats screen shows streak/trophies from seeded sessions', (
    tester,
  ) async {
    await seedStatsScenario();

    app.main();
    await tester.pumpAndSettle();

    expect(find.text('Copia Library'), findsOneWidget);
    await tester.tap(find.byKey(const Key('library_stats_button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('stats_summary_card')), findsOneWidget);
    expect(find.text('Streak: 3 days'), findsOneWidget);
    expect(find.text('3-day streak'), findsOneWidget);
    expect(find.byKey(const Key('stats_share_button')), findsOneWidget);
  });
}
