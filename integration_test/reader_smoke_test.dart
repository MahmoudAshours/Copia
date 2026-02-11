import 'package:copia/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'test_support.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('reader bookmark, notes, drawing, and tts sheet smoke', (
    tester,
  ) async {
    final seeded = await seedReaderDocument();

    app.main();
    await tester.pumpAndSettle();

    expect(find.text('Copia Library'), findsOneWidget);

    await tester.tap(find.text(seeded.title));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('reader_toggle_bookmark_button')),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const Key('reader_toggle_bookmark_button')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('reader_edit_note_button')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextField).first,
      'integration note update',
    );
    await tester.tap(find.byKey(const Key('reader_note_save_button')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('reader_notes_button')));
    await tester.pumpAndSettle();
    expect(find.textContaining('integration note update'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('reader_annotation_mode_button')));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const Key('reader_annotation_settings_button')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Show marker layer'), findsOneWidget);
    expect(find.text('Show pen layer'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('reader_tts_queue_button')));
    await tester.pumpAndSettle();
    expect(find.text('TTS Queue Controller'), findsOneWidget);
    expect(find.text('Load PDF'), findsOneWidget);
    expect(find.text('Load Doc'), findsOneWidget);
  });
}
