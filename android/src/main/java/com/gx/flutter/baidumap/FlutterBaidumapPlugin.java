package com.gx.flutter.baidumap;

import android.app.Activity;
import android.content.Intent;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterBaidumapPlugin */
public class FlutterBaidumapPlugin implements MethodCallHandler {

  private static MethodChannel channel;
  private Activity activity;

  private BaiduLocation baiduLocation;

  public FlutterBaidumapPlugin(Activity activity) {
    this.activity = activity;
    this.baiduLocation = new BaiduLocation(activity, channel);
  }

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    channel = new MethodChannel(registrar.messenger(), "flutter_baidumap");
    channel.setMethodCallHandler(new FlutterBaidumapPlugin(registrar.activity()));
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    String method = call.method;
    switch (method) {
      case "getPlatformVersion":
        result.success("Android " + android.os.Build.VERSION.RELEASE);
        break;
      case "open":
        this.openMapView(call, result);
        break;
      case "getCurrentPosition":
        this.baiduLocation.getCurrentLocation(result);
        break;
      case "startLocate":
        this.baiduLocation.startLocate();
        result.success(true);
        break;
      case "stopLocate":
        this.baiduLocation.stopLocate();
        result.success(true);
        break;
      default:
        result.notImplemented();
    }
  }

  public void openMapView(MethodCall call, Result result) {
    Intent intent = new Intent();
    intent.setClass(this.activity, MapViewActivity.class);
    intent.putExtra("title", "地图");
    // this.activity.startActivity(intent);
    this.activity.startActivityForResult(intent, 0);
  }

}
