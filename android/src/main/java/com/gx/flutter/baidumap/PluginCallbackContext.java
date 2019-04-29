package com.gx.flutter.baidumap;

import android.content.Intent;

import org.json.JSONException;

public interface PluginCallbackContext {

    void onActivityResult(int requestCode, Intent data) throws JSONException;

}
