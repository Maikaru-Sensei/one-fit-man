import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:one_fit_man/bloc/running/running_event.dart';
import 'package:one_fit_man/bloc/running/running_state.dart';
import 'package:one_fit_man/models/home/pose_action.dart';
import 'package:one_fit_man/models/permission/permission_state.dart';
import 'package:one_fit_man/repositories/permission/permission_repository.dart';
import 'package:one_fit_man/repositories/running/running_repository.dart';
import 'package:one_fit_man/repositories/storage/storage_repository.dart';

class RunningBloc extends Bloc<RunningEvent, RunningState> {
  final RunningRepository runningRepository;
  final PermissionRepository permissionRepository;
  final StorageRepository storageRepository;

  RunningBloc(
      {required this.runningRepository,
      required this.permissionRepository,
      required this.storageRepository})
      : super(RunningState.empty()) {
    on<RunningPermissionEvent>(
        (event, emit) async => _onRunningPermissionEvent(event, emit));
    on<RunningStartEvent>(
        (event, emit) async => _onRunningStartEvent(event, emit));
    on<RunningStopEvent>(
        (event, emit) async => _onRunningStopEvent(event, emit));
    on<RunningUpdateEvent>(
        (event, emit) async => _onRunningUpdateEvent(event, emit));
  }

  Future<void> _onRunningPermissionEvent(
      RunningPermissionEvent event, Emitter<RunningState> emit) async {
    final permission =
        await permissionRepository.requestPermission(PermissionType.location);

    emit(RunningState(
        isRunning: false,
        startingPosition: null,
        currentPosition: null,
        locationPermissionState: permission.permissionState,
        poseAction: PoseAction(type: PoseType.running, done: 0, total: 10),
        speed: 0.0));
  }

  Future<void> _onRunningStartEvent(
      RunningStartEvent event, Emitter<RunningState> emit) async {
    final startingPosition = await runningRepository.getCurrentPosition();

    await runningRepository.positionSubscription?.cancel();

    emit(state.copyWith(
        isRunning: true,
        poseAction: state.poseAction..done = 0,
        startingPosition: startingPosition));

    runningRepository.startPositionUpdates((Position newPosition) {
      final distance =
          runningRepository.calculateDistance(startingPosition, newPosition);
      final speed =
          runningRepository.calculateSpeed(state.currentPosition, newPosition);
      add(RunningUpdateEvent(
          distance: distance, speed: speed, currentPosition: newPosition));
    });
  }

  Future<void> _onRunningUpdateEvent(
      RunningUpdateEvent event, Emitter<RunningState> emit) async {
    await storageRepository.writePoseAction(state.poseAction);

    emit(state.copyWith(
        poseAction: state.poseAction..done = event.distance,
        isFinished: event.distance >= state.poseAction.total,
        currentPosition: event.currentPosition,
        speed: event.speed));
  }

  Future<void> _onRunningStopEvent(
      RunningStopEvent event, Emitter<RunningState> emit) async {
    runningRepository.stopPositionUpdates();
    emit(state.copyWith(isRunning: false, speed: 0.0));
  }
}
