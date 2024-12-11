import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_fit_man/bloc/pose/pose_event.dart';
import 'package:one_fit_man/bloc/pose/pose_state.dart';
import 'package:one_fit_man/models/home/pose_action.dart';
import 'package:one_fit_man/models/permission/permission_state.dart';
import 'package:one_fit_man/repositories/permission/permission_repository.dart';
import 'package:one_fit_man/repositories/pose/pose_repository.dart';

class PoseBloc extends Bloc<PoseEvent, PoseState> {
  final PoseRepository poseRepository;
  final PermissionRepository permissionRepository;

  PoseBloc({required this.poseRepository, required this.permissionRepository})
      : super(PoseState.empty()) {
    on<PoseRequestPermissionEvent>(
        (event, emit) async => _onPoseRequestPermissionEvent(event, emit));

    on<PoseProcessPosesEvent>(
        (event, emit) async => _onPoseProcessPosesEvent(event, emit));
  }

  Future<void> _onPoseRequestPermissionEvent(
      PoseRequestPermissionEvent event, Emitter<PoseState> emit) async {
    final permission =
        await permissionRepository.requestPermission(PermissionType.camera);
    emit(PoseState(
        poseAction: event.poseAction,
        cameraPermissionState: permission.permissionState));
  }

  Future<void> _onPoseProcessPosesEvent(
      PoseProcessPosesEvent event, Emitter<PoseState> emit) async {
    final didCount = state.poseAction?.type == PoseType.squat
        ? await poseRepository.countAsSquat(event.poses)
        : await poseRepository.countAsPushUp(event.poses);

    if (didCount) {
      state.poseAction?.done++;
    }

    emit(PoseProcessedState(
        didCount: didCount,
        poseAction: state.poseAction,
        cameraPermissionState: state.cameraPermissionState));
  }
}
