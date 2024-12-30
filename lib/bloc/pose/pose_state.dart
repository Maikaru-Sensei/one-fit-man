import 'package:one_fit_man/models/home/pose_action.dart';
import 'package:one_fit_man/models/permission/permission_state.dart';

class PoseState {
  final PoseAction? poseAction;
  final PermissionState? cameraPermissionState;
  final DateTime? lastPoseUpdated;

  PoseState(
      {required this.poseAction,
      required this.cameraPermissionState,
      required this.lastPoseUpdated});

  PoseState.empty()
      : poseAction = PoseAction(type: PoseType.unknown, done: 0, total: 10),
        cameraPermissionState = PermissionState.denied,
        lastPoseUpdated = null;

  PoseState copyWith({
    PoseAction? poseAction,
    PermissionState? cameraPermissionState,
    DateTime? lastPoseUpdated,
  }) =>
      PoseState(
        poseAction: poseAction ?? this.poseAction,
        cameraPermissionState:
            cameraPermissionState ?? this.cameraPermissionState,
        lastPoseUpdated: lastPoseUpdated ?? this.lastPoseUpdated,
      );
}

class PoseProcessedState extends PoseState {
  final bool didCount;

  PoseProcessedState({
    required this.didCount,
    required super.poseAction,
    required super.cameraPermissionState,
    required super.lastPoseUpdated,
  });
}
