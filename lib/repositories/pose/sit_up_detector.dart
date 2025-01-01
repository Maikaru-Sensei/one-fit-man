import 'dart:math';

import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:one_fit_man/models/pose/pose_result.dart';
import 'package:one_fit_man/repositories/pose/pose_recognizer.dart';

class SitUpDetector extends PoseRecognizer {
  SitUpDetector();

  static bool _isInSittingPosition = false;

  @override
  PoseResult didCount(List<Pose> poses, DateTime lastPoseUpdated) {
    for (final pose in poses) {
      final now = DateTime.now();

      if (_isSitting(pose)) {
        if (!_isInSittingPosition) {
          _isInSittingPosition = true;
        }
      } else if (_isReclined(pose)) {
        if (_isInSittingPosition) {
          _isInSittingPosition = false;
          if (now.difference(lastPoseUpdated) > const Duration(seconds: 1)) {
            return PoseResult(didCount: true, lastPoseUpdated: now);
          }
        }
      }
    }

    return PoseResult(didCount: false, lastPoseUpdated: lastPoseUpdated);
  }

  bool _isSitting(Pose pose) {
    PoseLandmark? shoulder = pose.landmarks[PoseLandmarkType.rightShoulder] ??
        pose.landmarks[PoseLandmarkType.leftShoulder];
    PoseLandmark? hip = pose.landmarks[PoseLandmarkType.rightHip] ??
        pose.landmarks[PoseLandmarkType.leftHip];
    PoseLandmark? knee = pose.landmarks[PoseLandmarkType.rightKnee] ??
        pose.landmarks[PoseLandmarkType.leftKnee];

    if (shoulder == null || hip == null || knee == null) {
      return false;
    }

    // Calculate torso angle (shoulder → hip → knee)
    double torsoAngle = _calculateAngle(
      shoulder.x,
      shoulder.y,
      hip.x,
      hip.y,
      knee.x,
      knee.y,
    );

    const double sittingThreshold = 50;
    return torsoAngle < sittingThreshold;
  }

  bool _isReclined(Pose pose) {
    PoseLandmark? shoulder = pose.landmarks[PoseLandmarkType.rightShoulder] ??
        pose.landmarks[PoseLandmarkType.leftShoulder];
    PoseLandmark? hip = pose.landmarks[PoseLandmarkType.rightHip] ??
        pose.landmarks[PoseLandmarkType.leftHip];
    PoseLandmark? knee = pose.landmarks[PoseLandmarkType.rightKnee] ??
        pose.landmarks[PoseLandmarkType.leftKnee];

    if (shoulder == null || hip == null || knee == null) {
      return false;
    }

    double torsoAngle = _calculateAngle(
      shoulder.x,
      shoulder.y,
      hip.x,
      hip.y,
      knee.x,
      knee.y,
    );

    const double reclinedThreshold = 145;
    return torsoAngle > reclinedThreshold;
  }

  double _calculateAngle(
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
}
