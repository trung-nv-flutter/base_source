import 'string_extensions.dart';
import 'dart:convert';

extension MapExtensions on Map {
  String toPostManParams() {
    if (this == null) return "";
    final strings = List<String>();
    if (keys.length == 0) return "";
    for (var key in keys) {
      strings.add("$key:${this[key]}");
    }
    return strings.join("\n");
  }

  String toQuery() {
    if (this == null) return null;
    final strings = List<String>();
    for (var key in keys) {
      strings.add("$key=${this[key]}");
    }
    return strings.join("&");
  }

  String getString(String key) {
    if (this == null) return null;
    if (this.keys.contains(key)) {
      final value = this[key];
      if (value == null) return "";
      if (value is String) return value;
    }
    return "";
  }

  bool getBool(String key, {bool defaultValue}) {
    if (this == null) return null;
    if (this.keys.contains(key)) {
      var value = this[key];
      if (value is String) value = int.parse(value);
      return value == 1;
    }
    return defaultValue;
  }

  double getDouble(String key) {
    if (this == null) return 0;
    if (this.keys.contains(key)) {
      final value = this[key];
      if (value is double) return value;
      if (value is String) {
        if (value.trim().length != 0) return double.parse(value);
      }
    }
    return 0;
  }

  DateTime getDate(String key, {String format = 'yyyy/MM/dd HH:mm:ss'}) {
    if (this == null) return null;
    if (!this.keys.contains(key)) return null;
    final value = this[key];
    if (value is String) return value.toDate(format);
    return null;
  }

  int getInt(String key) {
    if (this == null) return 0;
    if (this.keys.contains(key)) {
      final value = this[key];
      if (value is int) return value;
      if (value is String) {
        if (value.trim().length != 0) return int.parse(value);
      }
    }
    return 0;
  }

  String toJSON() {
    return json.encode(this);
  }
}
