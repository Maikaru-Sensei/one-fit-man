import 'package:one_fit_man/models/home/pose_action.dart';

class HomeState {
  PoseAction? squat;
  PoseAction? pushUp;
  PoseAction? sitUp;
  PoseAction? running;

  HomeState({this.squat, this.pushUp, this.sitUp, this.running});

  HomeState.empty() {
    squat = PoseAction(type: PoseType.squat, done: 0, total: 10);
    pushUp = PoseAction(type: PoseType.pushUp, done: 0, total: 10);
    sitUp = PoseAction(type: PoseType.sitUp, done: 0, total: 10);
    running = PoseAction(type: PoseType.running, done: 0, total: 10);
  }

  HomeState copyWith(
      {PoseAction? squat,
      PoseAction? pushUp,
      PoseAction? sitUp,
      PoseAction? running}) {
    return HomeState(
        squat: squat ?? this.squat,
        pushUp: pushUp ?? this.pushUp,
        sitUp: sitUp ?? this.sitUp,
        running: running ?? this.running);
  }
}
