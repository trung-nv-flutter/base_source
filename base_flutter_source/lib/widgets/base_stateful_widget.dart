import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';

import 'base_loading_indicator.dart';

// ignore: must_be_immutable
class BaseStateFulWidget extends StatefulWidget {
  BuildContext widgetContext;
  _BaseStateFulWidgetState _currentState;
  BaseLoadingIndicator loadingIndicator;
  bool mounted = false;

  // public functions
  init() {}
  initState() {}
  viewDidLoad() {}
  viewRenderFinished() {
    print("${this} viewRenderFinished");
  }

  didChangeDependencies() {}
  dispose() {}
  reload({VoidCallback function}) {
    _currentState?.reload(fn: function);
  }

  BaseStateFulWidget({Key key}) : super(key: key) {
    init();
  }

  @override
  State<StatefulWidget> createState() {
    _currentState = _BaseStateFulWidgetState();
    return _currentState;
  }

  Widget build(BuildContext context) {
    return Container();
  }

  BuildContext _indicatorContext;

  Future<void> showLoading(bool flag, {Widget indicator}) async {
    if (flag) {
      if (_indicatorContext != null) return; //still loading
      if (indicator == null) indicator = BaseLoadingIndicator();
      await Navigator.of(widgetContext).push(
        PageRouteBuilder(
          opaque: false,
          pageBuilder: (context, animation1, animation2) {
            _indicatorContext = context;
            return indicator;
          },
        ),
      );
    } else {
      if (_indicatorContext != null) {
        Navigator.of(_indicatorContext).pop();
      }
    }
  }
}

class _BaseStateFulWidgetState extends State<BaseStateFulWidget>
    with AfterLayoutMixin<BaseStateFulWidget> {
  reload({VoidCallback fn}) {
    try {
      // ignore: invalid_use_of_protected_member
      if (fn == null)
        setState(() {});
      else
        setState(fn);
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    widget.initState();
    widget.mounted = this.mounted;
  }

  @override
  void dispose() {
    widget.dispose();
    widget.showLoading(false);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    print("${widget} didChangeDependencies");
    widget.didChangeDependencies();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.viewRenderFinished();
    });
    widget.widgetContext = context;
    return widget.build(context);
  }

  @override
  void afterFirstLayout(BuildContext context) {
    widget.viewDidLoad();
  }
}
