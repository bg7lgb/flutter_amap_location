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

  static Future<void> stopLocation() async {
    await _channel.invokeMethod("stopLocation");
  }

  static listenLocation(EventHandler onEvent, EventHandler onError) {
    _stream.receiveBroadcastStream().listen(onEvent, onError: onError );
  }

}
