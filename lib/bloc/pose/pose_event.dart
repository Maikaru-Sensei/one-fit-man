import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:one_fit_man/models/home/pose_action.dart';

abstract class PoseEvent {}

class PoseRequestPermissionEvent extends PoseEvent {
  final PoseAction? poseAction;

  PoseRequestPermissionEvent({required this.poseAction});
}

class PoseProcessPosesEvent extends PoseEvent {
  final List<Pose> poses;

  PoseProcessPosesEvent({required this.poses});
}
