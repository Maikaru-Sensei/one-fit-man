import 'dart:math';

import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:one_fit_man/models/pose/pose_result.dart';
import 'package:one_fit_man/repositories/pose/pose_recognizer.dart';

class SquatDetector extends PoseRecognizer {
  SquatDetector();

  static bool _isInSquattingPosition = false;

  @override
  PoseResult didCount(List<Pose> poses, DateTime lastPoseUpdated) {
    print('isInSquattingPosition: $_isInSquattingPosition');
    for (final pose in poses) {
      final now = DateTime.now();

      if (_isSquat(pose)) {
        if (!_isInSquattingPosition) {
          // Transitioned from standing to squatting
          _isInSquattingPosition = true;
          print('standing to squatting: $_isInSquattingPosition');
        }
      } else if (_isInStandingPosition(pose)) {
        if (_isInSquattingPosition) {
          // Completed a squat (squatting → standing transition)
          _isInSquattingPosition = false;
          print('Squat detected');
          if (now.difference(lastPoseUpdated) > const Duration(seconds: 1)) {
            return PoseResult(didCount: true, lastPoseUpdated: now);
          }
        }
      }
    }

    return PoseResult(didCount: false, lastPoseUpdated: lastPoseUpdated);
  }

  bool _isSquat(Pose pose) {
    PoseLandmark? shoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
    PoseLandmark? hip = pose.landmarks[PoseLandmarkType.leftHip];
    PoseLandmark? knee = pose.landmarks[PoseLandmarkType.leftKnee];

    if (shoulder == null || hip == null || knee == null) return false;

    double torsoAngle = _calculateAngle(
      shoulder.x,
      shoulder.y,
      hip.x,
      hip.y,
      knee.x,
      knee.y,
    );

    // Squatting when torso angle is less than 90 degrees
    const double squatAngleThreshold = 90;
    print('_isSquat: $torsoAngle');
    return torsoAngle < squatAngleThreshold;
  }

  bool _isInStandingPosition(Pose pose) {
    PoseLandmark? shoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
    PoseLandmark? hip = pose.landmarks[PoseLandmarkType.leftHip];
    PoseLandmark? knee = pose.landmarks[PoseLandmarkType.leftKnee];

    if (shoulder == null || hip == null || knee == null) return false;

    double torsoAngle = _calculateAngle(
      shoulder.x,
      shoulder.y,
      hip.x,
      hip.y,
      knee.x,
      knee.y,
    );

    // Standing when torso angle is more than 160 degrees
    const double standAngleThreshold = 160;
    print('_isInStandingPosition: $torsoAngle');
    return torsoAngle > standAngleThreshold;
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
