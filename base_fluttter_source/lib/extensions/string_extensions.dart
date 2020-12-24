import 'package:intl/intl.dart';

extension StringExtension on String {
  bool isValid() {
    if (this == null) return false;
    if (this.trim().length == 0) return false;
    return true;
  }

  DateTime toDate([String format = ""]) {
    if (!isValid()) return null;
    final date = DateFormat(format).parse(this);
    return date;
  }
}
