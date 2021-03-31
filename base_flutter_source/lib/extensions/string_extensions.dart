import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
// import './context_extensions.dart';
import 'dart:io';

extension StringExtension on String {
  bool isValid() {
    if (this == null) return false;
    if (this.trim().length == 0) return false;
    return true;
  }

  DateTime toDate([String format = ""]) {
    if (!isValid()) return null;
    final date = DateFormat(format).parse(this);
    return date;
  }

  // void alert(BuildContext context, {String cancelTitle}) {
  //   if (context == null) return;
  //   context.alert(message: this, cancelTitle: cancelTitle);
  // }

  Future<bool> isPath() async {
    final file = File(this);
    bool flag = await file.exists();
    return flag;
  }
}
