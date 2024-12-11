import 'package:one_fit_man/models/permission/permission_state.dart';

class PermissionResult {
  final PermissionType permissionType;
  final PermissionState permissionState;

  PermissionResult(
      {required this.permissionType, required this.permissionState});
}
