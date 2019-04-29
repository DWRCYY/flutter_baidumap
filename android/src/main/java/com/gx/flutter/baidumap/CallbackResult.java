package com.gx.flutter.baidumap;

import com.google.gson.Gson;

import java.util.HashMap;
import java.util.Map;

public class CallbackResult {

    public static final int RESULT_SUCCESS = 0;
    public static final int RESULT_ERROR = -1;

    private static String result(int status, Object data, String message) {
        Map<String, Object> dataMap = new HashMap<>();
        dataMap.put("status", status);
        dataMap.put("data", data);
        dataMap.put("message", message);
        return (new Gson()).toJson(dataMap);
    }

    public static String success(Object data) {
        return result(RESULT_SUCCESS, data, null);
    }

    public static String error(String message) {
        return result(RESULT_ERROR, null, message);
    }

}
