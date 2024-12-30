import 'package:geolocator/geolocator.dart';
import 'package:one_fit_man/models/home/pose_action.dart';
import 'package:one_fit_man/models/permission/permission_state.dart';

class RunningState {
  final bool isRunning;
  final Position? startingPosition;
  final Position? currentPosition;
  final PoseAction poseAction;
  final PermissionState? locationPermissionState;
  final double speed;
  final bool isFinished;

  RunningState(
      {required this.isRunning,
      required this.startingPosition,
      required this.currentPosition,
      required this.poseAction,
      required this.locationPermissionState,
      required this.speed,
      this.isFinished = false});

  RunningState.empty()
      : isRunning = false,
        startingPosition = null,
        currentPosition = null,
        poseAction = PoseAction(type: PoseType.running, done: 0, total: 10),
        locationPermissionState = PermissionState.denied,
        speed = 0.0,
        isFinished = false;

  RunningState copyWith({
    bool? isRunning,
    Position? startingPosition,
    Position? currentPosition,
    PoseAction? poseAction,
    PermissionState? locationPermissionState,
    double? speed,
    bool? isFinished,
  }) =>
      RunningState(
        isRunning: isRunning ?? this.isRunning,
        startingPosition: startingPosition ?? this.startingPosition,
        currentPosition: currentPosition ?? this.currentPosition,
        poseAction: poseAction ?? this.poseAction,
        locationPermissionState:
            locationPermissionState ?? this.locationPermissionState,
        speed: speed ?? this.speed,
        isFinished: isFinished ?? this.isFinished,
      );
}
