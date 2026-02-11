import 'package:copia/core/services/copia_manifest_codec.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('checksum is deterministic regardless of key order', () {
    final first = <String, dynamic>{
      'version': 2,
      'documentMeta': {'title': 'Book', 'lastPage': 3},
      'bookmarks': [1, 2],
    };
    final second = <String, dynamic>{
      'bookmarks': [1, 2],
      'documentMeta': {'lastPage': 3, 'title': 'Book'},
      'version': 2,
    };

    final c1 = CopiaManifestCodec.manifestChecksum(first);
    final c2 = CopiaManifestCodec.manifestChecksum(second);
    expect(c1, c2);
  });

  test('validateChecksum returns true for untampered manifest', () {
    final base = <String, dynamic>{
      'version': 2,
      'documentMeta': {'title': 'Book'},
    };
    final manifest = Map<String, dynamic>.from(base)
      ..['checksum'] = CopiaManifestCodec.manifestChecksum(base);

    expect(CopiaManifestCodec.validateChecksum(manifest), isTrue);
  });

  test('validateChecksum returns false for tampered manifest', () {
    final base = <String, dynamic>{
      'version': 2,
      'documentMeta': {'title': 'Book'},
    };
    final manifest = Map<String, dynamic>.from(base)
      ..['checksum'] = CopiaManifestCodec.manifestChecksum(base);
    (manifest['documentMeta'] as Map<String, dynamic>)['title'] = 'Other';

    expect(CopiaManifestCodec.validateChecksum(manifest), isFalse);
  });
}
