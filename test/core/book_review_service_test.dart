import 'package:copia/core/services/book_review_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('saveReview persists rating and review', () async {
    SharedPreferences.setMockInitialValues({});
    final service = BookReviewService();

    await service.saveReview(
      documentId: 7,
      rating: 4,
      review: 'Excellent pacing.',
    );

    final all = await service.loadAll();
    expect(all[7]?.rating, 4);
    expect(all[7]?.review, 'Excellent pacing.');
  });

  test('loadAll returns empty map when storage is empty', () async {
    SharedPreferences.setMockInitialValues({});
    final service = BookReviewService();
    final all = await service.loadAll();
    expect(all, isEmpty);
  });
}
