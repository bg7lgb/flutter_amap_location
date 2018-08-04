import 'dart:async';

import 'package:flutter/services.dart';

typedef void EventHandler(Object event);

// 定位模式
// AMapLocationMode.BATTERY_SAVING 低功耗模式，只使用网络定位（基站和WIFI）
// AMapLocationMode.DEVICE_SENSORS 设备定位，只使用GPS，不需要联网，支持返回地址描述信息
// AMapLocationMode.HIGH_ACCURACY 高精度定位，同时使用GPS和网络定位，优先返回高精度结果，以及对应的地址描述信息
enum AMapLocationMode { BATTERY_SAVING, DEVICE_SENSORS, HIGH_ACCURACY }

// 定位场景
// SIGNIN：签到
// TRANSPORT：出行
// SPORT：运动
enum AMapLocationPurpose { SIGNIN, TRANSPORT, SPORT }

class FlutterAmapLocation {
  static const String METHOD_CHANNEL_NAME = "bg7lgb/amap_location";
  static const String EVENT_CHANNEL_NAME = "bg7lgb/amap_location_stream";

  static const MethodChannel _channel =
      const MethodChannel(METHOD_CHANNEL_NAME);

  static const EventChannel _stream = const EventChannel(EVENT_CHANNEL_NAME);

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
    await _channel.invokeMethod("startLocation");
  }

  static listenLocation(EventHandler onEvent, EventHandler onError) {
    _stream.receiveBroadcastStream().listen(onEvent, onError: onError);
  }

  // 设置定位时间间隔，单位ms，默认值2000ms
  //static Future<void> setInterval(int interval) async {
  static setInterval(int interval) {
    _channel.invokeMethod("setInterval", {"interval": interval});
  }

  // 设置一次定位
  // true：启动单次定位
  // false：使用默认的连续定位
  static setOnceLocation(bool isOnceLocation) {
    _channel
        .invokeMethod("setOnceLocation", {"isOnceLocation": isOnceLocation});
  }

  // 设置一次定位，获取最近3秒内精度最高的一次定位结果
  // true：启动单次定位，返回最近3秒内精度最高的一次定位结果
  // false：使用默认的连续定位
  static setOnceLocationLatest(bool isOnceLocationLatest) {
    _channel.invokeMethod("setOnceLocationLatest",
        {"isOnceLocationLatest": isOnceLocationLatest});
  }

  // 设置定位模式, 默认是高精度定位模式
  static setLocationMode(AMapLocationMode mode) {
    _channel.invokeMethod("setLocationMode", {"locationMode": mode});
  }

  // 设置是否返回地址信息，默认是返回地址信息
  static setNeedAddress(bool isNeedAddress) {
    _channel.invokeMethod("setNeedAddress", {"isNeedAddress": isNeedAddress});
  }

  // 设置是否允许软件模拟位置，默认是允许
  static setMockEnable(bool isMockEnable) {
    _channel.invokeMethod("setMockEnable", {"isMockEnable": isMockEnable});
  }

  // 设置定位请求超时时间，默认是30000毫秒（30秒）
  // 建议超时时间设置不低于8000毫秒（8秒）
  static setHttpTimeOut(int timeout) {
    _channel.invokeMethod("setHttpTimeOut", {"timeout": timeout});
  }

  // 设置是否开启定位缓存机制，默认为开启
  // true : 开启
  // false : 关闭
  static setLocationCacheEnable(bool isLocationCacheEnable) {
    _channel.invokeMethod("setLocationCacheEnable",
        {"isLocationCacheEnable": isLocationCacheEnable});
  }

  // 设置定位场景模式
  // 一共有3种模式：签到、出行、运动，默认无模式
  static setLocationPurpose(AMapLocationPurpose purpose) {
    _channel.invokeMethod("setLocationPurpose", {"locationPurpose": purpose});
  }
}
