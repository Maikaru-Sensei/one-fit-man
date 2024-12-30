enum PoseType {
  squat,
  pushUp,
  sitUp,
  running,
  unknown;

  String get name {
    switch (this) {
      case PoseType.squat:
        return 'Squats';
      case PoseType.pushUp:
        return 'Push Ups';
      case PoseType.sitUp:
        return 'Sit Ups';
      case PoseType.running:
        return 'Running';
      default:
        return '';
    }
  }
}

class PoseAction {
  final PoseType type;
  int done;
  int total;

  PoseAction({
    required this.type,
    required this.done,
    required this.total,
  });
}
