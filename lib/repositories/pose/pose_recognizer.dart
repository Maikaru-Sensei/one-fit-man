import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:one_fit_man/models/home/pose_action.dart';
import 'package:one_fit_man/models/pose/pose_result.dart';
import 'package:one_fit_man/repositories/pose/push_up_detector.dart';
import 'package:one_fit_man/repositories/pose/sit_up_detector.dart';
import 'package:one_fit_man/repositories/pose/squat_detector.dart';

abstract class PoseRecognizer {
  const PoseRecognizer();

  PoseResult didCount(List<Pose> poses, DateTime lastPoseUpdated);

  static PoseRecognizer? fromPoseType(PoseType? type) {
    switch (type) {
      case PoseType.squat:
        return SquatDetector();
      case PoseType.pushUp:
        return PushUpDetector();
      case PoseType.sitUp:
        return SitUpDetector();
      case PoseType.running:
      // TODO: Handle this case.
      case PoseType.unknown:
        return null;
      case null:
        return null;
    }
  }
}
