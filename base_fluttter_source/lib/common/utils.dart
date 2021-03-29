import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import './enums.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Utils {
  static bool isAndroid() {
    return Platform.isAndroid;
  }

  static bool isIOS() {
    return Platform.isIOS;
  }

  static bool isWeb() {
    return kIsWeb;
  }

  static BuildConfiguration getBuildConfiguration() {
    var result = BuildConfiguration.Profile;
    if (kReleaseMode == true) result = BuildConfiguration.Release;
    if (kDebugMode == true) result = BuildConfiguration.Debug;
    print(result);
    return result;
  }

  static Future<void> saveDataWithKey(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value == null) {
      prefs.remove(key);
      return;
    }
    if (value is String) prefs.setString(key, value);
    if (value is int) prefs.setInt(key, value);
    if (value is double) prefs.setDouble(key, value);
    if (value is bool) prefs.setBool(key, value);
  }

  static setTimeOut(Duration duration, VoidCallback callback) {
    Timer(duration, () => callback());
  }

  static void loadConfiguration() async {
    final type = getBuildConfiguration();
    String fileName;
    if (type == BuildConfiguration.Debug) fileName = 'assets/env/debug.env';
    if (type == BuildConfiguration.Profile) fileName = 'assets/env/profile.env';
    if (type == BuildConfiguration.Release) fileName = 'assets/env/release.env';
    await DotEnv.load(fileName: fileName);
  }

  static Future<bool> isInternetConnected() async {
    if (isAndroid() || isIOS()) {
      final connectivityResult = await (Connectivity().checkConnectivity());
      return connectivityResult != ConnectivityResult.none;
    }
    if (isWeb()) {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          // print('connected');
          return true;
        }
      } on SocketException catch (_) {
        // print('not connected');
      }
      return false;
    }
  }
}
