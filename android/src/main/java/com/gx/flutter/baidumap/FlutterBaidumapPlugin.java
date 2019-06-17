package com.gx.flutter.baidumap;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Map;
import java.util.Set;

import io.flutter.plugin.common.JSONUtil;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterBaidumapPlugin */
public class FlutterBaidumapPlugin implements MethodCallHandler, PluginCallbackContext {

  public static FlutterBaidumapPlugin instance;
  private static MethodChannel channel;
  private MethodCall call;
  private MethodChannel.Result channelResult;
  private Activity activity;

  private String action;
  private BaiduLocation baiduLocation;

  public FlutterBaidumapPlugin(Activity activity) {
    instance = this;
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
    this.call = call;
    this.channelResult = result;

    String method = call.method;
    switch (method) {
      case "getPlatformVersion":
        result.success("Android " + android.os.Build.VERSION.RELEASE);
        break;
      case "open":
      case "chooseLocation":
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
    Map<String, Object> args = this.call.arguments();
    if (args == null || !args.containsKey("action")) {
      result.error(CallbackResult.RESULT_ERROR + "", "Invaild arguments", null);
      return;
    }
    String action = this.call.argument("action");

    Intent intent = new Intent();
    intent.setClass(this.activity, MapViewActivity.class);
    intent.putExtra("title", "地图");
    intent.putExtra("action", action);
    intent.putExtra("data", JSONUtils.from(call.argument("data")));
    // this.activity.startActivity(intent);
    this.activity.startActivity(intent);
  }

  @Override
  public void onActivityResult(int requestCode, Intent data) throws JSONException {
    Bundle bundle = data.getExtras();
    Set<String> keys = bundle.keySet();
    JSONObject jsonObject = new JSONObject();
    for (String key : keys) {
      jsonObject.put(key, bundle.get(key));
    }
    System.out.println(jsonObject.toString());
    this.channelResult.success(jsonObject.toString());
  }
}
