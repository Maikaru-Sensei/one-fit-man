import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:one_fit_man/models/home/pose_action.dart';

class StorageRepository {
  final _squatsDoneKey = 'squats_done';
  final _pushUpsDoneKey = 'push_ups_done';
  final _sitUpsDoneKey = 'sit_ups_done';
  final _runningDoneKey = 'running_done';
  final _squatsTotalKey = 'squats_total';
  final _pushUpsTotalKey = 'push_ups_total';
  final _sitUpsTotalKey = 'sit_ups_total';
  final _runningTotalKey = 'running_total';

  final storage = const FlutterSecureStorage();

  Future<void> writePoseAction(PoseAction poseAction,
      {bool updateTotal = false}) async {
    final doneKey = _getDoneKey(poseAction.type);

    await storage.write(key: doneKey, value: poseAction.done.toString());

    if (updateTotal) {
      final totalKey = _getTotalKey(poseAction.type);
      await storage.write(key: totalKey, value: poseAction.total.toString());
    }
  }

  Future<PoseAction> readPoseAction(PoseAction poseAction) async {
    final doneKey = _getDoneKey(poseAction.type);
    final totalKey = _getTotalKey(poseAction.type);

    final done = await storage.read(key: doneKey);
    final total = await storage.read(key: totalKey);

    poseAction.done = int.tryParse(done ?? '0') ?? 0;
    poseAction.total = int.tryParse(total ?? '0') ?? 0;

    return poseAction;
  }

  String _getDoneKey(PoseType type) {
    switch (type) {
      case PoseType.squat:
        return _squatsDoneKey;
      case PoseType.pushUp:
        return _pushUpsDoneKey;
      case PoseType.sitUp:
        return _sitUpsDoneKey;
      case PoseType.running:
        return _runningDoneKey;
      case PoseType.unknown:
        return 'unknown';
    }
  }

  String _getTotalKey(PoseType type) {
    switch (type) {
      case PoseType.squat:
        return _squatsTotalKey;
      case PoseType.pushUp:
        return _pushUpsTotalKey;
      case PoseType.sitUp:
        return _sitUpsTotalKey;
      case PoseType.running:
        return _runningTotalKey;
      case PoseType.unknown:
        return 'unknown';
    }
  }
}
