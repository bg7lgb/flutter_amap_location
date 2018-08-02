import 'dart:async';

import 'package:flutter/services.dart';

typedef void EventHandler(Object event);

class FlutterAmapLocation {
  static const String METHOD_CHANNEL_NAME = "bg7lgb/amap_location";
  static const String EVENT_CHANNEL_NAME = "bg7lgb/amap_location_stream";

  static const MethodChannel _channel =
      const MethodChannel(METHOD_CHANNEL_NAME);

  static const EventChannel _stream =
    const EventChannel(EVENT_CHANNEL_NAME);

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<void> getLocationOnce() async {
    await _channel.invokeMethod("getLocationOnce");
  }

  static Future<void> getLocation() async {
    await _channel.invokeMethod("getLocation");
  }

  // 停止定位
  static Future<void> stopLocation() async {
    await _channel.invokeMethod("stopLocation");
  }

  // 开始定位
  static Future<void> startLocation() async {
    print("startLocation called");
    await _channel.invokeMethod("startLocation");
  }

  static listenLocation(EventHandler onEvent, EventHandler onError) {
    _stream.receiveBroadcastStream().listen(onEvent, onError: onError );
  }

  // 设置定位时间间隔，单位ms，默认值2000ms
  //static Future<void> setInterval(int interval) async {
  static setInterval(int interval) {
      _channel.invokeMethod("setInterval", {"interval": interval});
  }

}
