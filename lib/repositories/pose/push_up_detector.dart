import 'dart:math';

import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:one_fit_man/models/pose/pose_result.dart';
import 'package:one_fit_man/repositories/pose/pose_recognizer.dart';

class PushUpDetector extends PoseRecognizer {
  PushUpDetector();

  static bool _isInPushDownPosition = false;

  @override
  PoseResult didCount(List<Pose> poses, DateTime lastPoseUpdated) {
    for (final pose in poses) {
      final now = DateTime.now();

      if (_isPushDown(pose)) {
        if (!_isInPushDownPosition) {
          // Transitioned from up to down position
          _isInPushDownPosition = true;
          print('up to down: $_isInPushDownPosition');
        }
      } else if (_isPushUp(pose)) {
        if (_isInPushDownPosition) {
          // Completed a push-up (down → up transition)
          _isInPushDownPosition = false;
          print('Push-up detected');
          if (now.difference(lastPoseUpdated) > const Duration(seconds: 1)) {
            return PoseResult(didCount: true, lastPoseUpdated: now);
          }
        }
      }
    }

    return PoseResult(didCount: false, lastPoseUpdated: lastPoseUpdated);
  }

  bool _isPushDown(Pose pose) {
    PoseLandmark? shoulder = pose.landmarks[PoseLandmarkType.rightShoulder] ??
        pose.landmarks[PoseLandmarkType.leftShoulder];
    PoseLandmark? elbow = pose.landmarks[PoseLandmarkType.rightElbow] ??
        pose.landmarks[PoseLandmarkType.leftElbow];
    PoseLandmark? wrist = pose.landmarks[PoseLandmarkType.rightWrist] ??
        pose.landmarks[PoseLandmarkType.leftWrist];

    if (shoulder == null || elbow == null || wrist == null) {
      return false;
    }

    // Calculate arm angle (elbow)
    double armAngle = _calculateAngle(
      shoulder.x,
      shoulder.y,
      elbow.x,
      elbow.y,
      wrist.x,
      wrist.y,
    );

    // Down position when arms are bent (< 90°)
    const double downAngleThreshold = 130;
    print('armAngle: $armAngle');
    print('isPushDown: ${armAngle < downAngleThreshold}');
    return armAngle < downAngleThreshold;
  }

  bool _isPushUp(Pose pose) {
    PoseLandmark? shoulder = pose.landmarks[PoseLandmarkType.rightShoulder] ??
        pose.landmarks[PoseLandmarkType.leftShoulder];
    PoseLandmark? elbow = pose.landmarks[PoseLandmarkType.rightElbow] ??
        pose.landmarks[PoseLandmarkType.leftElbow];
    PoseLandmark? wrist = pose.landmarks[PoseLandmarkType.rightWrist] ??
        pose.landmarks[PoseLandmarkType.leftWrist];

    PoseLandmark? hip = pose.landmarks[PoseLandmarkType.rightHip] ??
        pose.landmarks[PoseLandmarkType.leftHip];
    PoseLandmark? ankle = pose.landmarks[PoseLandmarkType.rightAnkle] ??
        pose.landmarks[PoseLandmarkType.leftAnkle];

    if (shoulder == null ||
        elbow == null ||
        wrist == null ||
        hip == null ||
        ankle == null) {
      return false;
    }

    // Calculate arm angle (elbow)
    double armAngle = _calculateAngle(
      shoulder.x,
      shoulder.y,
      elbow.x,
      elbow.y,
      wrist.x,
      wrist.y,
    );

    // Calculate body alignment angle (shoulder to hip to ankle)
    double bodyAngle = _calculateAngle(
      shoulder.x,
      shoulder.y,
      hip.x,
      hip.y,
      ankle.x,
      ankle.y,
    );

    // Up position when arms are straight (> 150°) and body alignment is correct (> 160°)
    const double upAngleThreshold = 130;
    const double bodyAlignmentThreshold = 160;

    print('armAngle: $armAngle, bodyAngle: $bodyAngle');
    print(
        'isPushUp: ${armAngle > upAngleThreshold && bodyAngle > bodyAlignmentThreshold}');
    return armAngle > upAngleThreshold && bodyAngle > bodyAlignmentThreshold;
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
