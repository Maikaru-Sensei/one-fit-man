import 'dart:async';

import 'package:geolocator/geolocator.dart';

class RunningRepository {
  DateTime? _lastUpdateTime;
  StreamSubscription<Position>? positionSubscription;

  Future<Position> getCurrentPosition() async =>
      await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);

  Stream<Position> getPositionStream() => Geolocator.getPositionStream();

  int calculateDistance(Position start, Position current) =>
      Geolocator.distanceBetween(
        start.latitude,
        start.longitude,
        current.latitude,
        current.longitude,
      ).toInt();

  double calculateSpeed(Position? current, Position newPosition) {
    final currentTime = DateTime.now();
    if (_lastUpdateTime == null) {
      _lastUpdateTime = currentTime;
      return 0.0;
    }
    final timeDifference = currentTime.difference(_lastUpdateTime!).inSeconds;

    if (timeDifference == 0) {
      return 0.0;
    }

    final distance = calculateDistance(current ?? newPosition, newPosition);

    final speed = (distance / 1000) / (timeDifference / 3600);

    _lastUpdateTime = currentTime;

    return speed;
  }

  void startPositionUpdates(Function(Position) onPositionUpdate) {
    positionSubscription = getPositionStream().listen(onPositionUpdate);
  }

  void stopPositionUpdates() {
    positionSubscription?.cancel();
    positionSubscription = null;
  }
}
