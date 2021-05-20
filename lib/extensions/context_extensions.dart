import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
import './string_extensions.dart';
import '../common/utils.dart';

// typedef PermissionCallback = void Function(
//     Permission permission, bool isGranted, bool isFirstTime);

extension BuidContextExtensions on BuildContext {
  Size get size {
    final mediaQuery = MediaQuery.of(this);
    return mediaQuery.size;
  }

  pop() {
    Navigator.of(this).pop();
  }

  // Future<bool> requestPermission(List<Permission> permissions) async {
  //   bool isAllGranted = true;
  //   Map<Permission, PermissionStatus> statuses = await permissions.request();
  //   statuses.forEach((key, value) {
  //     if (statuses[key] != PermissionStatus.granted) {
  //       isAllGranted = false;
  //     }
  //   });
  //   return isAllGranted;
  // }

  // void checkAndRequestPermission(
  //     List<Permission> permissions, PermissionCallback callback) async {
  //   int count = 0;
  //   for (var i = 0; i < permissions.length; i++) {
  //     final permission = permissions[i];
  //     var status = await permissions[i].status;
  //     if (status.isGranted) {
  //       count++;
  //       if (count == permissions.length) {
  //         callback(permission, true, false);
  //         break;
  //       }
  //     } else if (status.isUndetermined || status.isDenied) {
  //       var result = await requestPermission(permissions);
  //       callback(permission, result, status.isUndetermined);
  //       break;
  //     } else {}
  //   }
  // }

  alert(
      {String title,
      String message,
      String confirmTitle,
      String cancelTitle,
      VoidCallback confirmCallBack}) {
    if (this == null) return;
    Widget titleWidget;
    Widget contentWidget;
    Widget confirmButton;
    Widget cancelButton;
    BuildContext _dialogContext;

    if (title.isValid()) titleWidget = Text(title);
    if (message.isValid()) contentWidget = Text(message);
    List<Widget> actions = [];
    if (confirmTitle.isValid()) {
      confirmButton = FlatButton(
        child: Text(confirmTitle),
        onPressed: confirmCallBack,
      );
      actions.add(confirmButton);
    }

    if (cancelTitle.isValid()) {
      cancelButton = FlatButton(
        child: Text(cancelTitle),
        onPressed: () {
          _dialogContext.pop();
        },
      );
      actions.add(cancelButton);
    }

    final dialog = AlertDialog(
      title: titleWidget,
      content: contentWidget,
      actions: actions,
    );
    final widgetBuilder = (BuildContext _context) {
      _dialogContext = _context;
      if (Utils.isIOS()) {
        return dialog;
      }
      return WillPopScope(
        child: dialog,
        onWillPop: () async {
          return true;
        },
      );
    };
    showDialog(context: this, builder: widgetBuilder);
  }
}
