package com.gx.flutter.baidumap;

import com.baidu.mapapi.map.BaiduMap;
import com.baidu.mapapi.map.BitmapDescriptor;
import com.baidu.mapapi.map.BitmapDescriptorFactory;
import com.baidu.mapapi.map.MarkerOptions;
import com.baidu.mapapi.map.OverlayOptions;
import com.baidu.mapapi.model.LatLng;

public class MapViewManager {

    public static void addOverlay(BaiduMap map, LatLng latLng, int res) {
        BitmapDescriptor bitmap = BitmapDescriptorFactory.fromResource(res);
        OverlayOptions option = new MarkerOptions()
                .position(latLng)
                .icon(bitmap);
        map.addOverlay(option);
    }

    public static void clearOverlays(BaiduMap map) {
        map.clear();
    }

}
