import 'package:copia/core/eye_tracking/gaze_command_classifier.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('classifies left yaw as next page', () {
    final classifier = GazeCommandClassifier(yawThreshold: 10);
    final command = classifier.classify(
      yaw: -15,
      pitch: 0,
      now: DateTime(2026, 1, 1, 10, 0, 0),
    );
    expect(command, GazeCommand.nextPage);
  });

  test('classifies right yaw as previous page', () {
    final classifier = GazeCommandClassifier(yawThreshold: 10);
    final command = classifier.classify(
      yaw: 15,
      pitch: 0,
      now: DateTime(2026, 1, 1, 10, 0, 0),
    );
    expect(command, GazeCommand.previousPage);
  });

  test('ignores commands inside cooldown window', () {
    final classifier = GazeCommandClassifier(
      yawThreshold: 10,
      cooldown: const Duration(seconds: 1),
    );
    final first = classifier.classify(
      yaw: -15,
      pitch: 0,
      now: DateTime(2026, 1, 1, 10, 0, 0),
    );
    final second = classifier.classify(
      yaw: -15,
      pitch: 0,
      now: DateTime(2026, 1, 1, 10, 0, 0, 500),
    );
    expect(first, GazeCommand.nextPage);
    expect(second, GazeCommand.none);
  });
}
