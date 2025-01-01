import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:one_fit_man/models/home/pose_action.dart';
import 'package:one_fit_man/models/pose/pose_result.dart';
import 'package:one_fit_man/repositories/pose/pose_recognizer.dart';

class PoseRepository {
  PoseResult checkPose(
      PoseType? poseType, List<Pose> poses, DateTime? lastPoseUpdated) {
    final poseRecognizer = PoseRecognizer.fromPoseType(poseType);

    return poseRecognizer?.didCount(poses, lastPoseUpdated ?? DateTime.now()) ??
        PoseResult(
            didCount: false,
            lastPoseUpdated: lastPoseUpdated ?? DateTime.now());
  }
}
