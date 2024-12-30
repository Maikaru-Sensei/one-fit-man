import 'package:one_fit_man/models/permission/permission_result.dart';
import 'package:one_fit_man/models/permission/permission_state.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionRepository {
  PermissionState resolvePermissionState(PermissionStatus status) =>
      status.isGranted
          ? PermissionState.granted
          : status.isPermanentlyDenied
              ? PermissionState.permanentlyDenied
              : PermissionState.denied;

  Future<PermissionResult> checkPermission(
      PermissionType permissionType) async {
    final status = switch (permissionType) {
      PermissionType.camera => await Permission.camera.status,
      PermissionType.location => await Permission.location.status
    };

    return PermissionResult(
        permissionType: permissionType,
        permissionState: resolvePermissionState(status));
  }

  Future<PermissionResult> requestPermission(
      PermissionType permissionType) async {
    final status = switch (permissionType) {
      PermissionType.camera => await Permission.camera.request(),
      PermissionType.location => await Permission.location.request()
    };

    return PermissionResult(
        permissionType: permissionType,
        permissionState: resolvePermissionState(status));
  }
}
