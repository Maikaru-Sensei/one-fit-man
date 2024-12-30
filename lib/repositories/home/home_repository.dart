import 'package:one_fit_man/models/home/pose_action.dart';

class HomeRepository {
  Future<PoseAction> getSquats() async {
    return Future.delayed(
      const Duration(seconds: 1),
      () => PoseAction(type: PoseType.squat, done: 0, total: 10),
    );
  }

  Future<PoseAction> getPushUps() async {
    return Future.delayed(
      const Duration(seconds: 1),
      () => PoseAction(type: PoseType.pushUp, done: 0, total: 10),
    );
  }

  Future<PoseAction> getSitUps() async {
    return Future.delayed(
      const Duration(seconds: 1),
      () => PoseAction(type: PoseType.sitUp, done: 0, total: 10),
    );
  }

  Future<PoseAction> getRunning() async {
    return Future.delayed(
      const Duration(seconds: 1),
      () => PoseAction(type: PoseType.running, done: 0, total: 10),
    );
  }
}
