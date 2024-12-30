import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_fit_man/bloc/home/home_event.dart';
import 'package:one_fit_man/bloc/home/home_state.dart';
import 'package:one_fit_man/models/home/pose_action.dart';
import 'package:one_fit_man/repositories/home/home_repository.dart';
import 'package:one_fit_man/repositories/storage/storage_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository homeRepository;
  final StorageRepository storageRepository;

  HomeBloc({required this.homeRepository, required this.storageRepository})
      : super(HomeState.empty()) {
    on<HomeFetchEvent>((event, emit) async => _onHomeFetchEvent(event, emit));
  }

  Future<void> _onHomeFetchEvent(
      HomeFetchEvent event, Emitter<HomeState> emit) async {
    final squat = await storageRepository
        .readPoseAction(PoseAction(type: PoseType.squat, done: 0, total: 0));
    final pushUp = await storageRepository
        .readPoseAction(PoseAction(type: PoseType.pushUp, done: 0, total: 0));
    final sitUp = await storageRepository
        .readPoseAction(PoseAction(type: PoseType.sitUp, done: 0, total: 0));
    final running = await storageRepository
        .readPoseAction(PoseAction(type: PoseType.running, done: 0, total: 0));

    emit(state.copyWith(
        squat: squat, pushUp: pushUp, sitUp: sitUp, running: running));
  }
}
