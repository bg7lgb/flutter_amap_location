import 'dart:async';

import 'package:flutter/services.dart';

typedef void EventHandler(Object event);

///  LocationMode 定位模式
///
/// AMapLocationMode.BATTERY_SAVING 低功耗模式，只使用网络定位（基站和WIFI）
/// AMapLocationMode.DEVICE_SENSORS 设备定位，只使用GPS，不需要联网，支持返回地址描述信息
/// AMapLocationMode.HIGH_ACCURACY 高精度定位，同时使用GPS和网络定位，优先返回高精度结果，以及对应的地址描述信息
enum AMapLocationMode { BATTERY_SAVING, DEVICE_SENSORS, HIGH_ACCURACY }

/// LocationPurpose 定位场景
///
/// AMapLocationPurpose.SIGNIN：签到
/// AMapLocationPurpose.TRANSPORT：出行
/// AMapLocationPurpose.SPORT：运动
enum AMapLocationPurpose { SIGNIN, TRANSPORT, SPORT }

/// 高德定位类
///
class FlutterAmapLocation {
  static const String METHOD_CHANNEL_NAME = "bg7lgb/amap_location";
  static const String EVENT_CHANNEL_NAME = "bg7lgb/amap_location_stream";

  static const MethodChannel _channel =
      const MethodChannel(METHOD_CHANNEL_NAME);

  static const EventChannel _stream = const EventChannel(EVENT_CHANNEL_NAME);

//  static Future<String> get platformVersion async {
//    final String version = await _channel.invokeMethod('getPlatformVersion');
//    return version;
//  }

  /// get location once, 定位一次
  ///
  /// 使用了签到场景定位实现只定位一次，以后可能会将这个方法去掉
  static Future<void> getLocationOnce() async {
    await _channel.invokeMethod("getLocationOnce");
  }

  /// get location continue, 连续定位
  ///
  /// 使用了出行场景实现连续定位，以后可能会将这个方法去掉
  static Future<void> getLocation() async {
    await _channel.invokeMethod("getLocation");
  }

  /// stop location, 停止定位
  ///
  /// 当不需要定位时，调用此方法停止定位
  static Future<void> stopLocation() async {
    await _channel.invokeMethod("stopLocation");
  }

  /// start location, 开始定位
  ///
  /// 调用此方法开始进行定位，定位成功后，结果通过回调方法获取
  static Future<void> startLocation() async {
    await _channel.invokeMethod("startLocation");
  }

  /// set stream event callback, 设置StreamChannel的回调方法
  ///
  /// [onEvent]: 接收到StreamChannel发送来事件的处理方法, [onError]：接收到StreamChannel发送来错误事件的处理方法
  static listenLocation(EventHandler onEvent, EventHandler onError) {
    _stream.receiveBroadcastStream().listen(onEvent, onError: onError);
  }

  /// set location interval, 设置定位时间间隔
  ///
  /// [interval] 定位时间间隔，单位ms，默认值2000ms
  static setInterval(int interval) {
    _channel.invokeMethod("setInterval", {"interval": interval});
  }

  /// set location once, 设置一次定位
  ///
  /// [isOnceLocation] 是否进行一次定位
  /// [true]：启动单次定位  [false]：使用默认的连续定位
  static setOnceLocation(bool isOnceLocation) {
    _channel
        .invokeMethod("setOnceLocation", {"isOnceLocation": isOnceLocation});
  }

  /// 设置一次定位，获取最近3秒内精度最高的一次定位结果
  ///
  /// [isOnceLocationLatest] 是否设置一次定位，并获取最近3秒内精度最高的一次定位结果
  /// [true]：启动单次定位，返回最近3秒内精度最高的一次定位结果
  /// [false]：使用默认的连续定位
  static setOnceLocationLatest(bool isOnceLocationLatest) {
    _channel.invokeMethod("setOnceLocationLatest",
        {"isOnceLocationLatest": isOnceLocationLatest});
  }

  /// set location mode, 设置定位模式, 默认是高精度定位模式
  ///
  /// [mode], [AMapLocationMode]类型
  static setLocationMode(AMapLocationMode mode) {
    _channel.invokeMethod("setLocationMode", {"locationMode": mode});
  }

  /// set return address info or not, 设置是否返回地址信息，默认是返回地址信息
  ///
  /// [isNeedAddress]: [true] 返回地址信息  [false]不返回地址信息
  static setNeedAddress(bool isNeedAddress) {
    _channel.invokeMethod("setNeedAddress", {"isNeedAddress": isNeedAddress});
  }

  ///  设置是否允许软件模拟位置，默认是允许
  ///
  /// [isMockEnable]: [true] 允许  [false]不允许
  static setMockEnable(bool isMockEnable) {
    _channel.invokeMethod("setMockEnable", {"isMockEnable": isMockEnable});
  }

  /// 设置定位请求超时时间，默认是30000毫秒（30秒）
  ///
  /// [timeout]: 超时时间，单位毫秒，建议超时时间设置不低于8000毫秒（8秒）
  static setHttpTimeOut(int timeout) {
    _channel.invokeMethod("setHttpTimeOut", {"timeout": timeout});
  }

  /// 设置是否开启定位缓存机制，默认为开启
  ///
  /// [isLocationCacheEnable]: [true] 开启 [false] 关闭
  static setLocationCacheEnable(bool isLocationCacheEnable) {
    _channel.invokeMethod("setLocationCacheEnable",
        {"isLocationCacheEnable": isLocationCacheEnable});
  }

  /// set location purpose, 设置定位场景模式
  ///
  /// [purpose]: [AMapLocationPurpose]类型，一共有3种模式：签到、出行、运动，默认无模式
  static setLocationPurpose(AMapLocationPurpose purpose) {
    _channel.invokeMethod("setLocationPurpose", {"locationPurpose": purpose});
  }
}
