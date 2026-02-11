import 'package:copia/main.dart' as app;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('onboarding can be completed to reach library', (tester) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('onboarding_seen');

    app.main();
    await tester.pumpAndSettle();

    expect(find.text('Welcome To Copia 2.0'), findsOneWidget);

    await tester.tap(find.byKey(const Key('onboarding_next_button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('onboarding_next_button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('onboarding_next_button')));
    await tester.pumpAndSettle();

    expect(find.text('Copia Library'), findsOneWidget);
  });
}
