package com.bg7lgb.flutteramaplocation;

import android.app.Activity;
import android.util.Log;

import com.amap.api.location.AMapLocation;
import com.amap.api.location.AMapLocationClient;
import com.amap.api.location.AMapLocationClientOption;
import com.amap.api.location.AMapLocationListener;

import java.util.HashMap;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.EventChannel.EventSink;
import io.flutter.plugin.common.EventChannel.StreamHandler;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterAmapLocationPlugin */
public class FlutterAmapLocationPlugin implements MethodCallHandler, StreamHandler{

  private static final String STREAM_CHANNEL_NAME = "bg7lgb/amap_location_stream";
  private static final String METHOD_CHANNEL_NAME = "bg7lgb/amap_location";

  public AMapLocationListener mapLocationListener = null;
  public AMapLocationClient mapLocationClient = null;
  private AMapLocationClientOption mapLocationClientOption = null;

  private EventSink event;
  private Result result;

  private Activity activity;

  private FlutterAmapLocationPlugin(Activity activity) {
    this.activity = activity;

    mapLocationClientOption = new AMapLocationClientOption();
    mapLocationClient = new AMapLocationClient(activity.getApplicationContext());

    mapLocationListener = new AMapLocationListener() {
      @Override
      public void onLocationChanged(AMapLocation aMapLocation) {
        HashMap<String, Object> loc = new HashMap<>();
        if (aMapLocation != null) {
          if (aMapLocation.getErrorCode() == 0) {
            // 定位成功
            loc.put("latitude", aMapLocation.getLatitude());
            loc.put("longitude", aMapLocation.getLongitude());
            loc.put("country", aMapLocation.getCountry());
            loc.put("province", aMapLocation.getProvince());
            loc.put("city", aMapLocation.getCity());
            loc.put("district", aMapLocation.getDistrict());
            loc.put("street", aMapLocation.getStreet());
            loc.put("streetnum", aMapLocation.getStreetNum());
            loc.put("adcode", aMapLocation.getAdCode());
            loc.put("poiname", aMapLocation.getPoiName());
            loc.put("address", aMapLocation.getAddress());
            event.success(loc);
          } else {
            // 定位失败
            loc.put("errorcode", aMapLocation.getErrorCode());
            loc.put("errorinfo", aMapLocation.getErrorInfo());
            event.error("error", "get location error", loc);
          }
        }

      }
    };

    mapLocationClient.setLocationListener(mapLocationListener);

  }

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {

    final FlutterAmapLocationPlugin plugin = new FlutterAmapLocationPlugin(registrar.activity());

    final MethodChannel channel = new MethodChannel(registrar.messenger(), METHOD_CHANNEL_NAME);
    channel.setMethodCallHandler(plugin);

    final EventChannel positionChannel = new EventChannel(registrar.messenger(), STREAM_CHANNEL_NAME );
    positionChannel.setStreamHandler( plugin);
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
//    if (call.method.equals("getPlatformVersion")) {
//      result.success("Android " + android.os.Build.VERSION.RELEASE);
//    } else if (call.method.equals("getLocationOnce")) {
    if (call.method.equals("getLocationOnce")) {
      // 设置定位场景为签到模式
      mapLocationClientOption.setLocationPurpose(AMapLocationClientOption.AMapLocationPurpose.SignIn);

      if (null != mapLocationClient) {
        mapLocationClient.setLocationOption(mapLocationClientOption);
        mapLocationClient.stopLocation();
        mapLocationClient.startLocation();
      }
    } else if (call.method.equals("getLocation")) {

      // 设置定位场景为出行模式
      mapLocationClientOption.setLocationPurpose(AMapLocationClientOption.AMapLocationPurpose.Transport);

      if (null != mapLocationClient) {
        mapLocationClient.setLocationOption(mapLocationClientOption);
        //设置场景模式后最好调用一次stop，再调用start以保证场景模式生效
        mapLocationClient.stopLocation();
        mapLocationClient.startLocation();
      }
    } else if (call.method.equals("stopLocation")) {
      if (null != mapLocationClient) {
        mapLocationClient.setLocationOption(mapLocationClientOption);
        // 停止定位
        mapLocationClient.stopLocation();
      }
    } else if (call.method.equals("startLocation")) {
      if (null != mapLocationClient) {
        mapLocationClient.setLocationOption(mapLocationClientOption);
        // 开始定位
        mapLocationClient.startLocation();
      }
    } else if (call.method.equals("setInterval")) {
      // 设置定位时间间隔，单位为毫秒，默认为2000ms。
      int interval = call.argument("interval");
      if (interval <= 0) {
        return;
      }
      mapLocationClientOption.setInterval(interval);
    } else if (call.method.equals("setLocationMode")) {
      // 设置定位模式
      int mode = call.argument("locationMode");
      mapLocationClientOption.setLocationMode(AMapLocationClientOption.AMapLocationMode.values()[mode]);
   } else if (call.method.equals("setOnceLocation")) {
      // 设置一次定位模式
      boolean isOnceLocation = call.argument("isOnceLocation");
      mapLocationClientOption.setOnceLocation(isOnceLocation);
    } else if (call.method.equals("setOnceLocationLatest")) {
      // 设置一次定位模式，返回最近3秒定位结果中精度最高的一个
      boolean isOnceLocationLatest = call.argument("isOnceLocationLatest");
      mapLocationClientOption.setOnceLocation(isOnceLocationLatest);
    } else if (call.method.equals("setNeedAddress")) {
      // 设置是否返回地址信息
      boolean isNeedAddress = call.argument("isNeedAddress");
      mapLocationClientOption.setNeedAddress(isNeedAddress);
    } else if (call.method.equals("setMockEnable")) {
      // 设置是否允许模拟定位
      boolean isMockEnable = call.argument("isMockEnable");
      mapLocationClientOption.setMockEnable(isMockEnable);
    } else if (call.method.equals("setHttpTimeOut")) {
      // 设置定位请求超时时间
      int timeout = call.argument("timeout");
      if (timeout <= 0) {
        return;
      }
      mapLocationClientOption.setHttpTimeOut(timeout);
    } else if (call.method.equals("setLocationCacheEnable")) {
      // 设置是否开启定位缓存机制，默认为开启
      boolean isLocationCacheEnable = call.argument("isLocationCacheEnable");
      mapLocationClientOption.setLocationCacheEnable(isLocationCacheEnable);
    } else if (call.method.equals("setLocationPurpose")) {
      // 设置定位场景
      int purpose = call.argument("locationPurpose");
      mapLocationClientOption.setLocationPurpose(AMapLocationClientOption.AMapLocationPurpose.values()[purpose]);
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onListen(Object o, EventSink eventSink) {
    event = eventSink;
  }

  @Override
  public void onCancel(Object o) {
    event = null;
  }

}
