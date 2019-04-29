package com.gx.flutter.baidumap;

import android.content.Intent;
import android.os.Bundle;
import android.support.constraint.ConstraintLayout;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v7.app.ActionBar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Toast;

import com.baidu.mapapi.CoordType;
import com.baidu.mapapi.SDKInitializer;
import com.baidu.mapapi.map.BaiduMap;
import com.baidu.mapapi.map.MapStatus;
import com.baidu.mapapi.map.MapStatusUpdate;
import com.baidu.mapapi.map.MapStatusUpdateFactory;
import com.baidu.mapapi.map.MapView;
import com.baidu.mapapi.model.LatLng;

import java.util.Map;

public class MapViewActivity extends AppCompatActivity
        implements BaiduMap.OnMapStatusChangeListener {

    private MapViewMenuActionHandler menuActionHandler;

    private MapView mapView;
    private LatLng currentLocation;

    @Override
    protected void onCreate(Bundle bundle) {
        super.onCreate(bundle);
        setContentView(R.layout.activity_map_view);

        Intent intent = this.getIntent();
        String title = intent.getStringExtra("title");
        if (title == null || title.trim().length() == 0) {
            title = "MapView";
        }

        Toolbar toolbar = findViewById(R.id.toolbar);
        toolbar.setTitle(title);
//        toolbar.inflateMenu(R.menu.menu_map_view);
        setSupportActionBar(toolbar);

        ActionBar actionBar = this.getSupportActionBar();
        if (actionBar != null) {
            actionBar.setHomeButtonEnabled(true);
            actionBar.setDisplayHomeAsUpEnabled(true);
        }

        this.menuActionHandler = new MapViewMenuActionHandler(FlutterBaidumapPlugin.instance);

        SDKInitializer.initialize(this.getApplicationContext());
        SDKInitializer.setCoordType(CoordType.BD09LL);

        this.mapView = new MapView(this);
        this.mapView.getMap().setOnMapStatusChangeListener(this);

        ConstraintLayout mapContainer = findViewById(R.id.mapContainer);
        mapContainer.addView(this.mapView);

        this.initMap();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // return super.onCreateOptionsMenu(menu);
        this.getMenuInflater().inflate(R.menu.menu_map_view, menu);
        return true;
    }

    @Override
    public boolean onPrepareOptionsMenu(Menu menu) {
        MenuItem menuItem = menu.findItem(R.id.mi_ok);
        menuItem.setShowAsAction(MenuItem.SHOW_AS_ACTION_ALWAYS);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == android.R.id.home) {
        } else if (item.getItemId() == R.id.mi_ok) {
            this.menuActionHandler.onGetCurrentPosition(this.currentLocation);
        }
        this.finish();
        return true;
        // return super.onOptionsItemSelected(item);
    }

    private void initMap() {
        try {
            String data = this.getIntent().getStringExtra("data");
            if (data != null && data.trim().length() > 0) {
                Map<String, Object> args = JSONUtils.fromJson(data, Map.class);
                Object defaultLocation = args.get("defaultLocation");
                LatLng defaultLatLng = null;
                if (defaultLocation != null) {
                    double longitude = (double) ((Map<String, Object>) defaultLocation).get("longitude");
                    double latitude = (double) ((Map<String, Object>) defaultLocation).get("latitude");
                    defaultLatLng = new LatLng(latitude, longitude);

                    this.setDefaultMapStatus(defaultLatLng);
                }

                boolean showDefaultLocation = (boolean) args.get("showDefaultLocation");
                if (showDefaultLocation && defaultLatLng != null) {
                    MapViewManager.addOverlay(this.mapView.getMap(), defaultLatLng, R.drawable.pin_red_0);
                }

            }
        } catch (Exception e) {
            e.printStackTrace();
            Toast toast = Toast.makeText(this, R.string.invaild_arguments, Toast.LENGTH_SHORT);
            toast.show();
        }
    }

    public void setDefaultMapStatus(LatLng latLng) {
        MapStatusUpdate mapStatus = MapStatusUpdateFactory.newLatLngZoom(
                latLng, 12
        );
        this.mapView.getMap().setMapStatus(mapStatus);
    }

    @Override
    public void onMapStatusChangeStart(MapStatus mapStatus) {

    }

    @Override
    public void onMapStatusChangeStart(MapStatus mapStatus, int i) {

    }

    @Override
    public void onMapStatusChange(MapStatus mapStatus) {
        LatLng latLng = mapStatus.target;
        this.currentLocation = latLng;
    }

    @Override
    public void onMapStatusChangeFinish(MapStatus mapStatus) {
        this.currentLocation = mapStatus.target;
    }
}
