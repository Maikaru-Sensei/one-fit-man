import 'dart:math';

import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:one_fit_man/models/pose/pose_result.dart';

class PoseRepository {
  Future<PoseResult> countAsSquat(
      List<Pose> poses, DateTime lastPoseUpdated) async {
    for (final pose in poses) {
      if (_isSquat(pose)) {
        final now = DateTime.now();
        if (now.difference(lastPoseUpdated) > const Duration(seconds: 1)) {
          return PoseResult(didCount: true, lastPoseUpdated: now);
        }
      }
    }

    return PoseResult(didCount: false, lastPoseUpdated: lastPoseUpdated);
  }

  bool _isSquat(Pose pose) {
    PoseLandmark? leftHip = pose.landmarks[PoseLandmarkType.leftHip];
    PoseLandmark? leftKnee = pose.landmarks[PoseLandmarkType.leftKnee];
    PoseLandmark? leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle];

    if (leftHip == null || leftKnee == null || leftAnkle == null) return false;

    double kneeAngle = _calculateSquatAngle(
      leftHip.x,
      leftHip.y,
      leftKnee.x,
      leftKnee.y,
      leftAnkle.x,
      leftAnkle.y,
    );

    const double squatAngleThreshold = 90;
    const double standAngleThreshold = 160;

    // Check transitions
    if (kneeAngle < squatAngleThreshold) {
      return false;
    } else if (kneeAngle > standAngleThreshold) {
      return true;
    }

    return false;
  }

  double _calculateSquatAngle(
      double x1, double y1, double x2, double y2, double x3, double y3) {
    double vector1x = x1 - x2;
    double vector1y = y1 - y2;
    double vector2x = x3 - x2;
    double vector2y = y3 - y2;

    double dotProduct = (vector1x * vector2x) + (vector1y * vector2y);

    double magnitude1 = sqrt(vector1x * vector1x + vector1y * vector1y);
    double magnitude2 = sqrt(vector2x * vector2x + vector2y * vector2y);

    double angleRadians = acos(dotProduct / (magnitude1 * magnitude2));

    return angleRadians * (180 / pi);
  }

  Future<PoseResult> countAsPushUp(
      List<Pose> poses, DateTime lastPoseUpdated) async {
    await Future.delayed(const Duration(seconds: 4));

    return PoseResult(didCount: false, lastPoseUpdated: lastPoseUpdated);
  }
}
