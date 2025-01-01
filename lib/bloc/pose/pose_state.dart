import 'package:one_fit_man/models/home/pose_action.dart';
import 'package:one_fit_man/models/permission/permission_state.dart';

class PoseState {
  final PoseAction? poseAction;
  final PermissionState? cameraPermissionState;
  final DateTime? lastPoseUpdated;
  final bool isFinished;

  PoseState(
      {required this.poseAction,
      required this.cameraPermissionState,
      required this.lastPoseUpdated,
      this.isFinished = false});

  PoseState.empty()
      : poseAction = PoseAction(type: PoseType.unknown, done: 0, total: 10),
        cameraPermissionState = PermissionState.denied,
        lastPoseUpdated = null,
        isFinished = false;

  PoseState copyWith({
    PoseAction? poseAction,
    PermissionState? cameraPermissionState,
    DateTime? lastPoseUpdated,
    bool? isFinished,
  }) =>
      PoseState(
        poseAction: poseAction ?? this.poseAction,
        cameraPermissionState:
            cameraPermissionState ?? this.cameraPermissionState,
        lastPoseUpdated: lastPoseUpdated ?? this.lastPoseUpdated,
        isFinished: isFinished ?? this.isFinished,
      );
}

class PoseProcessedState extends PoseState {
  final bool didCount;

  PoseProcessedState({
    required this.didCount,
    required super.poseAction,
    required super.cameraPermissionState,
    required super.lastPoseUpdated,
    required super.isFinished,
  });
}
