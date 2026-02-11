import 'package:copia/core/db/app_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('bookmark uniqueness is enforced per document/page', () async {
    final id = await db.createDocument(title: 'Doc', pdfPath: '/tmp/doc.pdf');

    await db.addBookmark(documentId: id, page: 5);
    await db.addBookmark(documentId: id, page: 5);

    final bookmarks = await db.watchBookmarks(id).first;
    expect(bookmarks, [5]);
  });

  test('upsert note replaces content for same page', () async {
    final id = await db.createDocument(title: 'Doc', pdfPath: '/tmp/doc.pdf');

    await db.upsertNote(documentId: id, page: 2, content: 'v1');
    await db.upsertNote(documentId: id, page: 2, content: 'v2');

    final note = await db.findNote(id, 2);
    expect(note?.content, 'v2');
  });
}
