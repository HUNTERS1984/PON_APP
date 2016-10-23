package com.hunters.pon.activities;

import android.Manifest;
import android.content.pm.PackageManager;
import android.location.Location;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
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
import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.LatLngBounds;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;
import com.hunters.pon.R;
import com.hunters.pon.adapters.CouponRecyclerViewAdapter;
import com.hunters.pon.api.APIConstants;
import com.hunters.pon.api.ResponseMapShopCoupon;
import com.hunters.pon.api.ResponseMapShopCouponData;
import com.hunters.pon.api.ShopAPIHelper;
import com.hunters.pon.models.CouponModel;
import com.hunters.pon.protocols.OnLoadDataListener;
import com.hunters.pon.utils.CommonUtils;
import com.hunters.pon.utils.DialogUtiils;
import com.hunters.pon.utils.PermissionUtils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class MapShopCouponActivity extends BaseActivity implements GoogleMap.OnMyLocationButtonClickListener,
        OnMapReadyCallback,
        ActivityCompat.OnRequestPermissionsResultCallback, OnLoadDataListener {

    private static final long MIN_TIME = 400;
    private static final float MIN_DISTANCE = 100;
    private static final int LOCATION_PERMISSION_REQUEST_CODE = 1;

    private GoogleMap mGoogleMap;
    private List<CouponModel> mListCoupons;
    private LatLng mUserLocation;
    private CouponRecyclerViewAdapter mAdapterCoupon;
    private Map<Long, List<CouponModel>> mHashMapOfShop;
    private LatLngBounds.Builder mBuilderShopMarker;

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
        if(mGoogleMap != null) {
            mGoogleMap.setMapType(GoogleMap.MAP_TYPE_NORMAL);
            mGoogleMap.setOnMyLocationButtonClickListener(this);
            mGoogleMap.getUiSettings().setMyLocationButtonEnabled(false);
            enableMyLocation();
            mGoogleMap.setOnMyLocationChangeListener(new GoogleMap.OnMyLocationChangeListener() {
                @Override
                public void onMyLocationChange(Location location) {
                    mUserLocation = new LatLng(location.getLatitude(), location.getLongitude());
                    if (!isShowMyLocationFirstTime) {
                        showMyLocation();
                        isShowMyLocationFirstTime = true;
//                        double lat = 10.839812;
//                        double lng = 106.780339;
//                        new ShopAPIHelper().getMapShopCoupon(mContext, lat, lng, "1", mHanlderGetMapShopCoupon);
                        new ShopAPIHelper().getMapShopCoupon(mContext, location.getLatitude(), location.getLongitude(), "1", mHanlderGetMapShopCoupon, true);
                    }
                }
            });
            mGoogleMap.setOnMarkerClickListener(new GoogleMap.OnMarkerClickListener() {
                @Override
                public boolean onMarkerClick(Marker marker) {
                    long shopId = Long.parseLong(marker.getTag().toString());
                    mAdapterCoupon.updateData(mHashMapOfShop.get(shopId));
                    return false;
                }
            });
        }
    }


    private void initLayout()
    {
        RecyclerView rvCoupons = (RecyclerView) findViewById(R.id.rv_list_coupons);
        LinearLayoutManager layoutManager = new LinearLayoutManager(this);
        layoutManager.setOrientation(LinearLayoutManager.HORIZONTAL);
        rvCoupons.setLayoutManager(layoutManager);
        mAdapterCoupon = new CouponRecyclerViewAdapter(this, mListCoupons);
        rvCoupons.setAdapter(mAdapterCoupon);

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
        mHashMapOfShop = new HashMap<>();
//        for(int i=0; i<5; i++) {
//            CouponModel coupon = new CouponModel();
//            coupon.setmTitle("タイトルが入ります");
//            coupon.setmExpireDate("2016-09-27T15:37:46+0000");
//            coupon.setmIsFavourite((i%2==0?1:0));
//            coupon.setmIsLoginRequired((i%2==0?1:0));
//            mListCoupons.add(coupon);
//        }
    }

    private void showMyLocation()
    {
        if(mUserLocation != null) {
            CameraUpdate camera = CameraUpdateFactory.newLatLngZoom(mUserLocation, 15);
            mGoogleMap.moveCamera(camera);
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

    private Handler mHanlderGetMapShopCoupon = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case APIConstants.HANDLER_REQUEST_SERVER_SUCCESS:
                    ResponseMapShopCouponData res = (ResponseMapShopCouponData) msg.obj;
                    if(res.code == APIConstants.REQUEST_OK && res.httpCode == APIConstants.HTTP_OK) {
                        mBuilderShopMarker = new LatLngBounds.Builder();
                        if(res.data != null && res.data.size() > 0) {
                            for (ResponseMapShopCoupon shop : res.data) {
                                addShopMarker(shop.getmId(), shop.getmShopName(), shop.getmAddress(), Double.parseDouble(shop.getmLatitude()), Double.parseDouble(shop.getmLongitude()));
                                mHashMapOfShop.put(shop.getmId(), shop.getmLstCoupons());
                            }

                            mAdapterCoupon.updateData(res.data.get(0).getmLstCoupons());
                        }
                        if(mGoogleMap != null) {
                            mBuilderShopMarker.include(mUserLocation);
                            LatLngBounds bounds = mBuilderShopMarker.build();
                            CameraUpdate cameraUpdate = CameraUpdateFactory.newLatLngBounds(bounds, CommonUtils.dpToPx(mContext, 50));
                            mGoogleMap.moveCamera(cameraUpdate);
                        }
                    } else {
                        new DialogUtiils().showDialog(mContext, getString(R.string.server_error), false);
                    }
                    break;
                case APIConstants.HANDLER_REQUEST_SERVER_FAILED:
                    new DialogUtiils().showDialog(mContext, getString(R.string.connection_failed), false);
                    break;
            }
        }
    };

    private void addShopMarker(long shopId, String shopName, String shopAddress, double lat, double lng)
    {
        if(mGoogleMap != null) {
            LatLng shopLoc = new LatLng(lat, lng);
            MarkerOptions optionMarker = new MarkerOptions().position(shopLoc);
            optionMarker.icon(BitmapDescriptorFactory.fromResource(R.drawable.ic_shop_marker));
            optionMarker.title(shopName).snippet(shopAddress);
            Marker marker = mGoogleMap.addMarker(optionMarker);
            marker.setTag(shopId);
            mBuilderShopMarker.include(shopLoc);
        }
    }
}
