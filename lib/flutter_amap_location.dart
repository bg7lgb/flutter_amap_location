import 'dart:async';

import 'package:flutter/services.dart';

class FlutterAmapLocation {
  static const String METHOD_CHANNEL_NAME = "bg7lgb/amap_location";

  static const MethodChannel _channel =
      const MethodChannel(METHOD_CHANNEL_NAME);

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> getLocationOnce() async {
    final String result = await _channel.invokeMethod("getLocationOnce");
    return result;
  }
}
