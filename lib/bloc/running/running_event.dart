import 'package:geolocator/geolocator.dart';

abstract class RunningEvent {}

class RunningFetchEvent extends RunningEvent {
  RunningFetchEvent();
}

class RunningPermissionEvent extends RunningEvent {
  RunningPermissionEvent();
}

class RunningStartEvent extends RunningEvent {
  RunningStartEvent();
}

class RunningStopEvent extends RunningEvent {
  RunningStopEvent();
}

class RunningUpdateEvent extends RunningEvent {
  final int distance;
  final double speed;
  final Position? currentPosition;

  RunningUpdateEvent(
      {required this.distance,
      required this.speed,
      required this.currentPosition});
}
