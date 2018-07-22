package com.bg7lgb.flutteramaplocation;

import android.app.Activity;
import android.util.Log;

import com.amap.api.location.AMapLocation;
import com.amap.api.location.AMapLocationClient;
import com.amap.api.location.AMapLocationClientOption;
import com.amap.api.location.AMapLocationListener;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.EventChannel.EventSink;
import io.flutter.plugin.common.EventChannel.StreamHandler;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterAmapLocationPlugin */
public class FlutterAmapLocationPlugin implements MethodCallHandler{

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
        Log.i(METHOD_CHANNEL_NAME, aMapLocation.getAddress());
        if (locateOnce)
          mapLocationClient.stopLocation();
      }
    };

    mapLocationClient.setLocationListener(mapLocationListener);

  }

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "bg7lgb/amap_location");
    channel.setMethodCallHandler(new FlutterAmapLocationPlugin(registrar.activity()));
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("getLocationOnce")) {
      locateOnce = true;
      mapLocationClientOption.setOnceLocation(true);

      mapLocationClient.setLocationOption(mapLocationClientOption);
      mapLocationClient.startLocation();
    } else {
      result.notImplemented();
    }
  }
}
