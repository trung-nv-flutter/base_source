import 'package:intl/intl.dart';

extension DateExtension on DateTime {
  String toStringWithFormat(String format) {
    final _format = DateFormat(format);
    final string = _format.format(this);
    return string;
  }

  DateTime setValues(
      {int hour, int minute, int second, int year, int month, int day}) {
    if (hour == null) hour = this.hour;
    if (minute == null) minute = this.minute;
    if (second == null) second = this.second;
    if (year == null) year = this.year;
    if (month == null) month = this.month;
    if (day == null) day = this.day;
    DateTime _date = DateTime(year, month, day, hour, minute, second, 0, 0);
    return _date;
  }

  DateTime get monthStartDay {
    return setValues(day: 1, hour: 0, minute: 0, second: 0);
  }

  DateTime get monthEndDay {
    final date = this
        .setValues(month: this.month + 1, day: 1)
        .subtract(Duration(days: 1));
    return date;
  }

  bool get isToday {
    return this.isSameDay(DateTime.now());
  }

  bool isSameDay(DateTime date) {
    return this.day == date.day &&
        this.year == date.year &&
        this.month == date.month;
  }

  int get monthDaysCount {
    final begin = monthStartDay;
    final end = monthEndDay;
    final days = end.difference(begin).inDays;
    return days;
  }
}
