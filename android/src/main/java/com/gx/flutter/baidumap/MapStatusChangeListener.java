package com.gx.flutter.baidumap;

import android.app.Activity;

import com.baidu.mapapi.map.BaiduMap;
import com.baidu.mapapi.map.MapStatus;

public interface MapStatusChangeListener extends BaiduMap.OnMapStatusChangeListener {

    @Override
    void onMapStatusChangeStart(MapStatus mapStatus);

    @Override
    void onMapStatusChangeStart(MapStatus mapStatus, int i);

    @Override
    void onMapStatusChange(MapStatus mapStatus);

    @Override
    void onMapStatusChangeFinish(MapStatus mapStatus);
}
