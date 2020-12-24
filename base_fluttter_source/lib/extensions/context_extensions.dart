import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

typedef PermissionCallback = void Function(
    Permission permission, bool isGranted, bool isFirstTime);

extension BuidContextExtensions on BuildContext {
  Size get size {
    final mediaQuery = MediaQuery.of(this);
    return mediaQuery.size;
  }

  Future<bool> requestPermission(List<Permission> permissions) async {
    bool isAllGranted = true;
    Map<Permission, PermissionStatus> statuses = await permissions.request();
    statuses.forEach((key, value) {
      if (statuses[key] != PermissionStatus.granted) {
        isAllGranted = false;
      }
    });
    return isAllGranted;
  }

  void checkAndRequestPermission(
      List<Permission> permissions, PermissionCallback callback) async {
    int count = 0;
    for (var i = 0; i < permissions.length; i++) {
      final permission = permissions[i];
      var status = await permissions[i].status;
      if (status.isGranted) {
        count++;
        if (count == permissions.length) {
          callback(permission, true, false);
          break;
        }
      } else if (status.isUndetermined || status.isDenied) {
        var result = await requestPermission(permissions);
        callback(permission, result, status.isUndetermined);
        break;
      } else {}
    }
  }
}
