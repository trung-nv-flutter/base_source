// ignore: must_be_immutable
import 'package:base_flutter_source/screen/base_screen.dart';
import 'package:base_flutter_source_test/hello_screen.dart';
import 'package:base_flutter_source/navigator/base_navigator.dart';
import 'package:base_flutter_source/extensions/string_extensions.dart';

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TestScreen extends BaseScreen {
  @override
  init() {
    this.checkApplicationState = true;
    return super.init();
  }

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
              this.push(HelloScreen(), transitionType: PageTransitionType.iOS);
            },
          ),
        ));

    return Scaffold(
      appBar: AppBar(),
      body: container,
    );
  }
}
