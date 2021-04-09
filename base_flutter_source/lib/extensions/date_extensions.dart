import 'package:intl/intl.dart';

extension DateExtension on DateTime {
  String toStringWithFormat(String format) {
    final _format = DateFormat(format);
    final string = _format.format(this);
    return string;
  }
}
