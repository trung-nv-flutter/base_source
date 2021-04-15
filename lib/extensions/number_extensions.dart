extension IntExtensions on int {
  String get timeDisplay {
    var time = this;
    int hours = time ~/ 3600;
    time -= hours * 3600;
    int minutes = time ~/ 60;
    time -= minutes * 60;
    int seconds = time;
    String hourString = "";
    final strings = List<String>();
    if (hours != 0) {
      hourString = hours.toString().padLeft(2, '0');
      strings.add(hourString);
    }
    strings.add(minutes.toString().padLeft(2, '0'));
    strings.add(seconds.toString().padLeft(2, '0'));
    return strings.join(":");
  }

  String withPadLeft({int padLeft = 0}) {
    return this.toString().padLeft(padLeft, '0');
  }
}
