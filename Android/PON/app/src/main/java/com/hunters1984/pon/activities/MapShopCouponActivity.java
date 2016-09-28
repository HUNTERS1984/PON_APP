package com.hunters1984.pon.activities;

import android.Manifest;
import android.content.pm.PackageManager;
import android.location.Location;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;

import com.google.android.gms.maps.CameraUpdate;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.MapFragment;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.model.LatLng;
import com.hunters1984.pon.R;
import com.hunters1984.pon.adapters.CouponRecyclerViewAdapter;
import com.hunters1984.pon.models.CouponModel;
import com.hunters1984.pon.protocols.OnLoadDataListener;
import com.hunters1984.pon.utils.PermissionUtils;

import java.util.ArrayList;
import java.util.List;

public class MapShopCouponActivity extends BaseActivity implements GoogleMap.OnMyLocationButtonClickListener,
        OnMapReadyCallback,
        ActivityCompat.OnRequestPermissionsResultCallback, OnLoadDataListener {

    private static final long MIN_TIME = 400;
    private static final float MIN_DISTANCE = 100;
    private static final int LOCATION_PERMISSION_REQUEST_CODE = 1;

    private GoogleMap mGoogleMap;
    private List<CouponModel> mListCoupons;
    private LatLng mUserLocation;

    private RelativeLayout mRlListCoupons;
    private ImageView mIvShowMyLocation1, mIvShowMyLocation2;


    /**
     * Flag indicating whether a requested permission has been denied after returning in
     * {@link #onRequestPermissionsResult(int, String[], int[])}.
     */
    private boolean mPermissionDenied = false;
    private boolean isShowMyLocationFirstTime = false;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        mContext = this;
        mDataListener = this;
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_map_shop_coupon);
        initCommonLayout();
        setTitle(getString(R.string.find_current_location));

        try {
            if (mGoogleMap == null) {
                ((MapFragment) getFragmentManager().
                        findFragmentById(R.id.map_shop)).getMapAsync(this);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        initLayout();
    }

    @Override
    public void onMapReady(GoogleMap googleMap) {
        mGoogleMap = googleMap;
        mGoogleMap.setMapType(GoogleMap.MAP_TYPE_NORMAL);
        mGoogleMap.setOnMyLocationButtonClickListener(this);
        mGoogleMap.getUiSettings().setMyLocationButtonEnabled(false);
        enableMyLocation();
        mGoogleMap.setOnMyLocationChangeListener(new GoogleMap.OnMyLocationChangeListener() {
            @Override
            public void onMyLocationChange(Location location) {
                mUserLocation = new LatLng(location.getLatitude(), location.getLongitude());
                if(!isShowMyLocationFirstTime) {
                    showMyLocation();
                    isShowMyLocationFirstTime = true;
                }
            }
        });
    }


    private void initLayout()
    {
        RecyclerView rvCoupons = (RecyclerView) findViewById(R.id.rv_list_coupons);
        LinearLayoutManager layoutManager = new LinearLayoutManager(this);
        layoutManager.setOrientation(LinearLayoutManager.HORIZONTAL);
        rvCoupons.setLayoutManager(layoutManager);
        CouponRecyclerViewAdapter adapter = new CouponRecyclerViewAdapter(this, mListCoupons);
        rvCoupons.setAdapter(adapter);

        mIvShowMyLocation1 = (ImageView)findViewById(R.id.iv_my_location_1);
        mIvShowMyLocation2 = (ImageView)findViewById(R.id.iv_my_location_2);

        mRlListCoupons = (RelativeLayout)findViewById(R.id.rl_list_coupons);
        final ImageView ivMenu = (ImageView)findViewById(R.id.iv_menu);
        ivMenu.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                mRlListCoupons.setVisibility(View.VISIBLE);
                ivMenu.setVisibility(View.GONE);
                mIvShowMyLocation1.setVisibility(View.GONE);
            }
        });

        ImageView ivHideCoupons = (ImageView)findViewById(R.id.iv_hide_list_coupons);
        ivHideCoupons.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                mRlListCoupons.setVisibility(View.GONE);
                ivMenu.setVisibility(View.VISIBLE);
                mIvShowMyLocation1.setVisibility(View.VISIBLE);
            }
        });



        mIvShowMyLocation1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                showMyLocation();
            }
        });

        mIvShowMyLocation2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                showMyLocation();
            }
        });
    }

    public void onLoadData() {
        mListCoupons = new ArrayList<>();
        for(int i=0; i<5; i++) {
            CouponModel coupon = new CouponModel();
            coupon.setmTitle("タイトルが入ります");
            coupon.setmExpireDate("2016-09-27T15:37:46+0000");
            coupon.setmIsFavourite((i%2==0?1:0));
            coupon.setmIsLoginRequired((i%2==0?1:0));
            mListCoupons.add(coupon);
        }
    }

    private void showMyLocation()
    {
        if(mUserLocation != null) {
            CameraUpdate camera = CameraUpdateFactory.newLatLngZoom(mUserLocation, 15);
            mGoogleMap.animateCamera(camera);
        }
    }

    private void enableMyLocation() {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
                != PackageManager.PERMISSION_GRANTED) {
            // Permission to access the location is missing.
            PermissionUtils.requestPermission(this, LOCATION_PERMISSION_REQUEST_CODE,
                    Manifest.permission.ACCESS_FINE_LOCATION, true);
        } else if (mGoogleMap != null) {
            // Access to the location has been granted to the app.
            mGoogleMap.setMyLocationEnabled(true);
        }
    }



    @Override
    public boolean onMyLocationButtonClick() {

        return false;
    }


    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions,
                                           @NonNull int[] grantResults) {
        if (requestCode != LOCATION_PERMISSION_REQUEST_CODE) {
            return;
        }

        if (PermissionUtils.isPermissionGranted(permissions, grantResults,
                Manifest.permission.ACCESS_FINE_LOCATION)) {
            // Enable the my location layer if the permission has been granted.
            enableMyLocation();
        } else {
            // Display the missing permission error dialog when the fragments resume.
            mPermissionDenied = true;
        }
    }

    @Override
    protected void onResumeFragments() {
        super.onResumeFragments();
        if (mPermissionDenied) {
            // Permission was not granted, display error dialog.
            showMissingPermissionError();
            mPermissionDenied = false;
        }
    }

    /**
     * Displays a dialog with error message explaining that the location permission is missing.
     */
    private void showMissingPermissionError() {
        PermissionUtils.PermissionDeniedDialog
                .newInstance(true).show(getSupportFragmentManager(), "dialog");
    }
}
