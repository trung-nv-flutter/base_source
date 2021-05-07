import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
// import './context_extensions.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sprintf/sprintf.dart';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;


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

  String get md5 {
    var content = new Utf8Encoder().convert(this);
    var digest = crypto.md5.convert(content);
    return hex.encode(digest.bytes);
  }

  // void alert(BuildContext context, {String cancelTitle}) {
  //   if (context == null) return;
  //   context.alert(message: this, cancelTitle: cancelTitle);
  // }
  String withFormat({List<dynamic> values}) {
    return sprintf(this, values);
  }

  String getFileName({bool withoutExtension = false}) {
    if (!this.isValid()) return null;
    File file = new File(this);
    String fileName;
    if (withoutExtension)
      fileName = basenameWithoutExtension(file.path);
    else
      fileName = basename(file.path);
    return fileName;
  }

  Future<bool> isPath() async {
    if (!this.isValid()) return false;
    final file = File(this);
    bool flag = await file.exists();
    return flag;
  }

  File assetsFile() {
    return File("assets/${this}");
  }
}
