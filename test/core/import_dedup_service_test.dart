import 'dart:io';

import 'package:copia/core/services/import_dedup_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('nextKeepBothTitle increments duplicate suffix', () {
    const service = ImportDedupService();
    final next = service.nextKeepBothTitle('Book', {'Book', 'Book (2)'});
    expect(next, 'Book (3)');
  });

  test('filesAreIdentical returns true for same content', () async {
    const service = ImportDedupService();
    final dir = await Directory.systemTemp.createTemp('dedup_test_');
    try {
      final a = File('${dir.path}/a.pdf')..writeAsBytesSync([1, 2, 3, 4]);
      final b = File('${dir.path}/b.pdf')..writeAsBytesSync([1, 2, 3, 4]);
      final same = await service.filesAreIdentical(a.path, b.path);
      expect(same, isTrue);
    } finally {
      await dir.delete(recursive: true);
    }
  });

  test('filesAreIdentical returns false for different content', () async {
    const service = ImportDedupService();
    final dir = await Directory.systemTemp.createTemp('dedup_test_');
    try {
      final a = File('${dir.path}/a.pdf')..writeAsBytesSync([1, 2, 3, 4]);
      final b = File('${dir.path}/b.pdf')..writeAsBytesSync([9, 2, 3, 4]);
      final same = await service.filesAreIdentical(a.path, b.path);
      expect(same, isFalse);
    } finally {
      await dir.delete(recursive: true);
    }
  });
}
