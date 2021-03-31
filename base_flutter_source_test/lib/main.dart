import 'package:base_fluttter_source_test/test_screen.dart';
import 'package:flutter/material.dart';

import 'package:base_fluttter_source/navigator/base_navigator.dart';

// import 'test_screen.dart';

void main() {
  final app = MaterialApp(
    home: TestNavigator(),
  );
  runApp(app);
}

class TestNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screen = TestScreen();
    final navigator = BaseNavigator(
      topScreen: screen,
    );
    return navigator;
  }
}
