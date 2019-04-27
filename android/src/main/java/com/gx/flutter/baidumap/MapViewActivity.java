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

import com.baidu.mapapi.CoordType;
import com.baidu.mapapi.SDKInitializer;
import com.baidu.mapapi.map.MapStatusUpdate;
import com.baidu.mapapi.map.MapStatusUpdateFactory;
import com.baidu.mapapi.map.MapView;
import com.baidu.mapapi.model.LatLng;

public class MapViewActivity extends AppCompatActivity {

    private MapView mapView;

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



        SDKInitializer.initialize(this.getApplicationContext());
        SDKInitializer.setCoordType(CoordType.BD09LL);

        this.mapView = new MapView(this);

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
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == android.R.id.home) {
            this.setResult(0);
            this.finish();
            return true;
        }
        return super.onOptionsItemSelected(item);
    }

    private void initMap() {
        MapStatusUpdate mapStatus = MapStatusUpdateFactory.newLatLngZoom(
                this.getDefaultLocation(), 12
        );
        this.mapView.getMap().setMapStatus(mapStatus);
    }

    public LatLng getDefaultLocation() {
        Intent intent = this.getIntent();
        double longitude = intent.getDoubleExtra("longitude", 120.179);
        double latitude = intent.getDoubleExtra("latitude", 30.256);
        return new LatLng(latitude, longitude);
    }
}
