package com.gx.flutter.baidumap;

import android.app.Activity;
import android.content.Intent;

import com.baidu.mapapi.model.LatLng;

import org.json.JSONException;

public class MapViewMenuActionHandler {

    private Activity activity;
    private PluginCallbackContext callbackContext;

    public MapViewMenuActionHandler(PluginCallbackContext callbackContext) {
        // this.activity = activity;
        this.callbackContext = callbackContext;
    }

    public void onGetCurrentPosition(LatLng latLng) {
        Intent data = new Intent();
        data.putExtra("longitude", latLng.latitude);
        data.putExtra("latitude", latLng.latitude);

        try {
            callbackContext.onActivityResult(0, data);
        } catch (JSONException e) {
            e.printStackTrace();
        }

    }

}
