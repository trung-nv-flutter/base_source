// ignore: must_be_immutable
import 'package:base_flutter_source/screen/base_screen.dart';
import 'package:base_flutter_source/navigator/base_navigator.dart';
import 'package:base_flutter_source/extensions/string_extensions.dart';
import 'package:base_flutter_source_test/test_screen.dart';
import 'package:flutter/material.dart';

class HelloScreen extends BaseScreen {
  @override
  Widget build(BuildContext context) {
    final container = Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.green,
        child: Center(
          child: GestureDetector(
            child: Text(this.routeName),
            onTap: () {
              // "hello".alert(this.widgetContext, cancelTitle: "Ok");
              // this.push(TestScreen(), transitionType: PageTransitionType.iOS);
            },
          ),
        ));

    return Scaffold(
      appBar: AppBar(),
      body: container,
    );
  }
}
