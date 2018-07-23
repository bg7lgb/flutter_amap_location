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
  private boolean locateOnce = false;

  private FlutterAmapLocationPlugin(Activity activity) {
    this.activity = activity;

    mapLocationClientOption = new AMapLocationClientOption();
    mapLocationClient = new AMapLocationClient(activity.getApplicationContext());

    mapLocationListener = new AMapLocationListener() {
      @Override
      public void onLocationChanged(AMapLocation aMapLocation) {
        HashMap<String, String> loc = new HashMap<>();
        if (aMapLocation != null) {
          if (aMapLocation.getErrorCode() == 0) {
            // 定位成功
            loc.put("latitude", Double.toString(aMapLocation.getLatitude()));
            loc.put("longitude", Double.toString(aMapLocation.getLongitude()));
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
            loc.put("errorcode", Integer.toString(aMapLocation.getErrorCode()));
            loc.put("errorinfo", aMapLocation.getErrorInfo());
            event.error("get location error", "", loc);
          }
        }

      }
    };

    mapLocationClient.setLocationListener(mapLocationListener);

  }

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {

    final FlutterAmapLocationPlugin plugin = new FlutterAmapLocationPlugin(registrar.activity());

    final MethodChannel channel = new MethodChannel(registrar.messenger(), "bg7lgb/amap_location");
    channel.setMethodCallHandler(plugin);

    final EventChannel positionChannel = new EventChannel(registrar.messenger(), "bg7lgb/amap_location_stream" );
    positionChannel.setStreamHandler( plugin);
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("getLocationOnce")) {
      // 设置定位场景为签到模式
      mapLocationClientOption.setLocationPurpose(AMapLocationClientOption.AMapLocationPurpose.SignIn);

      if (null != mapLocationClient) {
        mapLocationClient.setLocationOption(mapLocationClientOption);
        mapLocationClient.stopLocation();
        mapLocationClient.startLocation();
      }
    } else if (call.method.equals("getLocation")) {
      // 设置定位间隔5秒，默认2秒
      //mapLocationClientOption.setInterval(5000);

      // 设置定位场景为出行模式
      mapLocationClientOption.setLocationPurpose(AMapLocationClientOption.AMapLocationPurpose.Transport);

      if (null != mapLocationClient) {
        mapLocationClient.setLocationOption(mapLocationClientOption);
        //设置场景模式后最好调用一次stop，再调用start以保证场景模式生效
        mapLocationClient.stopLocation();
        mapLocationClient.startLocation();
      }
    } else if (call.method.equals("stopLocation")) {
      // 停止定位
      mapLocationClient.stopLocation();
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
