import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/base_stateful_widget.dart';
import '../navigator/base_navigator.dart';

const _VIEW_APPEAR_WAITING_TIME = 300; //miliseconds

// ignore: must_be_immutable
class BaseScreen extends BaseStateFulWidget with WidgetsBindingObserver {
  bool checkApplicationState = false;
  String routeName = "";

  //screen life cycle
  //init ->

  //public methods
  appBecomeActive() {}
  appBecomeDeactive() {}

  //detect if screen has been totally appeared
  bool _appeared = false;
  Timer _appearTimer;
  

  viewWillAppear() {
    _appeared = true;
    // print("${this} viewWillAppear");
    _startAppearTimer();
  }

  viewWillDisappear() {
    _appeared = false;
    _startAppearTimer(flag: false);
    // print("${this} viewWillDisappear");
  }

  viewDidAppear() {
    // print("${this} viewDidAppear");
  }

  BaseRouteController routeController;

  _startAppearTimer({bool flag = true}) {
    _appearTimer?.cancel();
    if (flag) {
      _appearTimer =
          Timer(Duration(milliseconds: _VIEW_APPEAR_WAITING_TIME), () {
        if (_appeared) {
          viewDidAppear();
        }
      });
    }
  }

  @override
  init() {
    routeName = this.runtimeType.toString();
    return super.init();
  }

  pop({dynamic value}) async {
    Navigator.of(widgetContext).pop(value);
  }

  pushAndReplace(BaseScreen screen, {PageTransitionType transitionType}) {
    final route =
        BaseRouteController(screen: screen, transitionType: transitionType);
    Navigator.of(widgetContext).pushReplacement(route.routeBuilder);
    screen.viewWillAppear();
  }

  push(BaseScreen screen, {PageTransitionType transitionType}) {
    final route =
        BaseRouteController(screen: screen, transitionType: transitionType);
    Navigator.of(widgetContext).push(route.routeBuilder);
  }

  @override
  dispose() {
    _startAppearTimer(flag: false);
    if (checkApplicationState) WidgetsBinding.instance?.removeObserver(this);
    return super.dispose();
  }

  @override
  didChangeDependencies() {
    if (checkApplicationState) {
      WidgetsBinding.instance?.removeObserver(this);
      WidgetsBinding.instance?.addObserver(this);
    }
    // print("WidgetsBinding.instance ${WidgetsBinding.instance}");
    return super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // print("didChangeAppLifecycleState ${this} ${state}");
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused)
      appBecomeDeactive();
    else if (state == AppLifecycleState.resumed) appBecomeActive();
    super.didChangeAppLifecycleState(state);
  }
}
