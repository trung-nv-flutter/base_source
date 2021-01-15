import 'package:base_fluttter_source/screen/base_screen.dart';
import 'package:flutter/material.dart';

class BaseInheritedWidget extends InheritedWidget {
  BaseInheritedWidget({Widget child, Key key})
      : super(child: child, key: key);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}
