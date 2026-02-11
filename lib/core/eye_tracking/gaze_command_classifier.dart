enum GazeCommand { nextPage, previousPage, none }

class GazeCommandClassifier {
  GazeCommandClassifier({
    this.yawThreshold = 12,
    this.pitchNeutralWindow = 20,
    this.cooldown = const Duration(milliseconds: 950),
  });

  final double yawThreshold;
  final double pitchNeutralWindow;
  final Duration cooldown;

  DateTime? _lastCommandAt;

  GazeCommand classify({
    required double yaw,
    required double pitch,
    required DateTime now,
  }) {
    if (_lastCommandAt != null && now.difference(_lastCommandAt!) < cooldown) {
      return GazeCommand.none;
    }

    if (pitch.abs() > pitchNeutralWindow) {
      return GazeCommand.none;
    }

    if (yaw <= -yawThreshold) {
      _lastCommandAt = now;
      return GazeCommand.nextPage;
    }
    if (yaw >= yawThreshold) {
      _lastCommandAt = now;
      return GazeCommand.previousPage;
    }

    return GazeCommand.none;
  }

  void resetCooldown() {
    _lastCommandAt = null;
  }
}
