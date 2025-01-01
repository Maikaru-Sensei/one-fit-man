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
    emit(HomeLoadingState());

    final squat = await storageRepository.readPoseAction(PoseType.squat);
    final pushUp = await storageRepository.readPoseAction(PoseType.pushUp);
    final sitUp = await storageRepository.readPoseAction(PoseType.sitUp);
    final running = await storageRepository.readPoseAction(PoseType.running);

    squat.done = 5;
    pushUp.done = 3;
    running.done = 0;
    running.total = 100;

    emit(HomeState(
        squat: squat, pushUp: pushUp, sitUp: sitUp, running: running));
  }
}
