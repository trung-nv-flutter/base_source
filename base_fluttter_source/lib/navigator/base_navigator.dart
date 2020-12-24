import 'package:base_fluttter_source/widgets/base_stateful_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screen/base_screen.dart';

enum PageTransitionType {
  iOS, //default is CupertinoPageRoute
  Fade,
  FromBottom,
}

// const _ANIMATION_DURATION = Duration(milliseconds: 300);

// ignore: must_be_immutable
class BaseNavigator extends BaseStateFulWidget with NavigatorObserver {
  final BaseScreen topScreen;

  BaseRouteController topRouteController;

  BaseNavigator({@required this.topScreen});

  Navigator _navigator;
  int pageCount = 0;

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    pageCount++;
    BaseRouteController routeController;
    BaseRouteController previousRouteController;

    if (route is _CupertinoPageRoute)
      routeController = route.routeController;
    else if (route is _PageRoute) routeController = route.routeController;

    topRouteController = routeController;
    topRouteController?.viewWillAppear();

    if (previousRoute is _CupertinoPageRoute)
      previousRouteController = previousRoute.routeController;
    else if (previousRoute is _PageRoute)
      previousRouteController = previousRoute.routeController;

    previousRouteController?.viewWillDisappear();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    pageCount--;
    BaseRouteController routeController;
    BaseRouteController previousRouteController;

    if (route is _CupertinoPageRoute)
      previousRouteController = route.routeController;
    else if (route is _PageRoute)
      previousRouteController = route.routeController;
    previousRouteController?.viewWillDisappear();

    if (previousRoute is _CupertinoPageRoute)
      routeController = previousRoute.routeController;
    else if (previousRoute is _PageRoute)
      routeController = previousRoute.routeController;
    topRouteController = routeController;
    routeController?.viewWillAppear();
  }

  @override
  Widget build(BuildContext context) {
    _navigator = Navigator(
        observers: [this],
        initialRoute: topScreen.routeName,
        onGenerateRoute: (RouteSettings settings) {
          final route = BaseRouteController(navigator: this, screen: topScreen);
          return route.routeBuilder;
        });
    return _navigator;
  }

  void viewWillAppear() {
    topRouteController?.viewWillAppear();
  }

  void viewWillDisappear() {
    topRouteController?.viewWillDisappear();
  }
}

class BaseRouteController {
  final BaseScreen screen;
  final BaseNavigator navigator;
  final PageTransitionType transitionType;

  String name;
  dynamic routeBuilder;

  BaseRouteController(
      {@required this.screen,
      this.navigator,
      this.transitionType = PageTransitionType.iOS}) {
    screen.routeController = this;
    name = screen.routeName;
    if (transitionType == PageTransitionType.iOS || transitionType == null) {
      routeBuilder = _CupertinoPageRoute(routeController: this);
    } else {
      routeBuilder =
          _PageRoute(routeController: this, transitionType: transitionType);
    }
  }
  viewWillAppear() {
    screen.viewWillAppear();
  }

  viewWillDisappear() {
    screen.viewWillDisappear();
  }
}

class _PageRoute extends PageRouteBuilder {
  final PageTransitionType transitionType;
  final BaseRouteController routeController;

  _PageRoute({@required this.routeController, this.transitionType})
      : super(
            pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) =>
                routeController.screen,
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              if (transitionType == PageTransitionType.Fade) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              }
              if (transitionType == PageTransitionType.FromBottom) {
                var begin = Offset(0.0, 1.0);
                var end = Offset.zero;
                var curve = Curves.ease;
                var tween = Tween(begin: begin, end: end);
                var curvedAnimation = CurvedAnimation(
                  parent: animation,
                  curve: curve,
                );
                return SlideTransition(
                  position: tween.animate(curvedAnimation),
                  child: child,
                );
              }
              return child;
            });
}

class _CupertinoPageRoute extends CupertinoPageRoute {
  final BaseRouteController routeController;
  _CupertinoPageRoute({@required this.routeController})
      : super(builder: (BuildContext context) => routeController.screen);
}
