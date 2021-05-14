import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ReloadableText extends StatefulWidget {
  _ReloadableTextState _currentState;
  double width = double.infinity;
  double height = double.infinity;
  Decoration decoration;
  TextStyle style;
  Alignment alignment;
  TextAlign textAlign;
  String text;

  ReloadableText(
      {Key key,
      this.width,
      this.height,
      this.decoration,
      this.style,
      this.alignment,
      this.textAlign,
      this.text = ""})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    _currentState = _ReloadableTextState();
    return _currentState;
  }

  reload(String _text) {
    if (_currentState == null) {
      return;
    }
    // ignore: invalid_use_of_protected_member
    _currentState?.setState(() {
      text = _text;
    });
  }
}

class _ReloadableTextState extends State<ReloadableText> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final label = Container(
        alignment: widget.alignment,
        height: widget.height,
        decoration: widget.decoration,
        child: Text(
          widget.text,
          textAlign: widget.textAlign,
          style: widget.style,
        ));

    return label;
  }
}
