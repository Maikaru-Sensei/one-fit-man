import 'package:one_fit_man/models/home/pose_action.dart';

class HomeState {
  PoseAction? squat;
  PoseAction? pushUp;

  HomeState({
    this.squat,
    this.pushUp,
  });

  HomeState.empty() {
    squat = PoseAction(type: PoseType.squat, done: 0, total: 10);
    pushUp = PoseAction(type: PoseType.pushUp, done: 0, total: 10);
  }

  HomeState copyWith({
    PoseAction? squat,
    PoseAction? pushUp,
  }) {
    return HomeState(
      squat: squat ?? this.squat,
      pushUp: pushUp ?? this.pushUp,
    );
  }
}
