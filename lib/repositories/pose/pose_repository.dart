import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class PoseRepository {
  Future<bool> countAsSquat(List<Pose> poses) async {
    await Future.delayed(const Duration(seconds: 2));

    return true;
  }

  Future<bool> countAsPushUp(List<Pose> poses) async {
    await Future.delayed(const Duration(seconds: 2));

    return true;
  }
}
