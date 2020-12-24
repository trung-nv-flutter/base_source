// ignore: must_be_immutable
import 'package:flutter/material.dart';

import 'base_stateful_widget.dart';

// ignore: must_be_immutable
class BaseLoadingIndicator extends BaseStateFulWidget {
  Widget _loadingWidget;

  show({@required BuildContext fromContext}) async {
    showDialog(context: fromContext, child: this);
    await Future.delayed(Duration(milliseconds: 200));
  }

  hide() {
    Navigator.of(widgetContext).pop();
  }

  @override
  Widget build(BuildContext context) {
    final spinkit = CircularProgressIndicator();
    const double spinSize = 60;
    final spinkitContainer = Container(
      height: spinSize,
      width: spinSize,
      child: spinkit,
    );

    _loadingWidget = AbsorbPointer(
      child: Container(
        child: Center(
          child: spinkitContainer,
        ),
      ),
    );
    return _loadingWidget;
  }
}
