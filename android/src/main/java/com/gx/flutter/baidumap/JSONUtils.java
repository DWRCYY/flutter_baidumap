package com.gx.flutter.baidumap;

import com.google.gson.Gson;

public class JSONUtils {

    public static <T> T fromJson(String json, Class T) {
        return (T) (new Gson()).fromJson(json, T);
    }

    public static String from(Object object) {
        return (new Gson()).toJson(object);
    }

}
