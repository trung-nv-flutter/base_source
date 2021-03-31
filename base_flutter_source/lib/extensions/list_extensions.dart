extension ListExtension on List {
  bool isValid() {
    if (this == null) return false;
    if (this.length == 0) return false;

    return true;
  }

  int indexOfNumberList(int value) {
    for (var i = 0; i < this.length; i++) {
      final _value = this[i];
      if (_value is String) {
        if (int.parse(_value) == value) return i;
      }
    }
    return 0;
  }
}
