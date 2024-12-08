enum PoseType {
  squat,
  pushUp;

  String get name {
    switch (this) {
      case PoseType.squat:
        return 'Squats';
      case PoseType.pushUp:
        return 'Push Ups';
      default:
        return '';
    }
  }
}

class PoseAction {
  final PoseType type;
  final int done;
  final int total;

  PoseAction({
    required this.type,
    required this.done,
    required this.total,
  });
}
