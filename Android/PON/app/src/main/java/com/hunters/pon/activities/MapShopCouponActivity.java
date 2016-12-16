package com.hunters.pon.activities;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.location.Location;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.annotation.NonNull;
import android.support.v4.app.ActivityCompat;
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
import com.hunters.pon.application.PonApplication;
import com.hunters.pon.customs.EndlessRecyclerViewScrollListener;
import com.hunters.pon.models.CouponModel;
import com.hunters.pon.models.ExtraDataModel;
import com.hunters.pon.utils.CommonUtils;
import com.hunters.pon.utils.Constants;
import com.hunters.pon.utils.DialogUtiils;
import com.hunters.pon.utils.GoogleAnalyticUtils;
import com.hunters.pon.utils.LocationUtils;
import com.hunters.pon.utils.PermissionUtils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class MapShopCouponActivity extends BaseActivity implements GoogleMap.OnMyLocationButtonClickListener,
        OnMapReadyCallback,
        ActivityCompat.OnRequestPermissionsResultCallback {

    private GoogleMap mGoogleMap;
    private List<CouponModel> mListCoupons;
    private LatLng mUserLocation;
    private CouponRecyclerViewAdapter mAdapterCoupon;
    private Map<Long, List<CouponModel>> mHashMapOfShop;
    private LatLngBounds.Builder mBuilderShopMarker;

    private RelativeLayout mRlListCoupons;
    private ImageView mIvShowMyLocation1, mIvShowMyLocation2;

    private EndlessRecyclerViewScrollListener mScrollLoadMoreData;
    private int mPageTotal;

    /**
     * Flag indicating whether a requested permission has been denied after returning in
     * {@link #onRequestPermissionsResult(int, String[], int[])}.
     */
    private boolean isShowMyLocationFirstTime = false;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        mContext = this;
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
        initData();
        initLayout();

        GoogleAnalyticUtils.getInstance(mContext).logScreenAccess((PonApplication)getApplication(), GoogleAnalyticUtils.MAP_SCREEN);
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
                        loadData();
//                        double lat = 10.839812;
//                        double lng = 106.780339;
//                        new ShopAPIHelper().getMapShopCoupon(mContext, lat, lng, "1", mHanlderGetMapShopCoupon, true);
//                        new ShopAPIHelper().getMapShopCoupon(mContext, location.getLatitude(), location.getLongitude(), "1", mHanlderGetMapShopCoupon, true);
                    }
                }
            });
//            mGoogleMap.setOnMarkerClickListener(new GoogleMap.OnMarkerClickListener() {
//                @Override
//                public boolean onMarkerClick(Marker marker) {
//                    long shopId = Long.parseLong(marker.getTag().toString());
//                    mAdapterCoupon.updateData(mHashMapOfShop.get(shopId));
//                    return false;
//                }
//            });
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if(requestCode == Constants.REQUEST_CODE_COUPON_DETAIL) {
            if (resultCode == Activity.RESULT_OK) {
                initData();
                loadData();
                ExtraDataModel extra =  (ExtraDataModel)data.getSerializableExtra(Constants.EXTRA_DATA);
                Intent iCouponDetail = new Intent(mContext, CouponDetailActivity.class);
                iCouponDetail.putExtra(Constants.EXTRA_COUPON_ID, extra.getmId());
                mContext.startActivity(iCouponDetail);
            }
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

        mScrollLoadMoreData = new EndlessRecyclerViewScrollListener(layoutManager) {
            @Override
            public void onLoadMore(int page, int totalItemsCount) {
                if(page < mPageTotal) {
                    mListCoupons.add(null);
                    mAdapterCoupon.notifyItemInserted(mListCoupons.size() - 1);
                    new ShopAPIHelper().getMapShopCoupon(mContext, mUserLocation.latitude, mUserLocation.longitude, String.valueOf(page + 1), mHanlderGetMapShopCoupon, false);
                }
            }
        };

        rvCoupons.addOnScrollListener(mScrollLoadMoreData);

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

    private void initData() {
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

    private void loadData()
    {
        if(mUserLocation != null) {
            if(mListCoupons == null) {
                mListCoupons = new ArrayList<>();
            }
            mListCoupons.clear();
//            double lat = 10.839812;
//            double lng = 106.780339;
//            new ShopAPIHelper().getMapShopCoupon(mContext, lat, lng, "1", mHanlderGetMapShopCoupon, true);
            new ShopAPIHelper().getMapShopCoupon(mContext, mUserLocation.latitude, mUserLocation.longitude, "1", mHanlderGetMapShopCoupon, true);
        }
    }

    private void showMyLocation()
    {
        if(mUserLocation != null) {
            CameraUpdate camera = CameraUpdateFactory.newLatLngZoom(mUserLocation, 15);
            mGoogleMap.moveCamera(camera);
        }
    }

    private void enableMyLocation() {
        if (!PermissionUtils.newInstance().isGrantLocationPermission(this)) {
            PermissionUtils.newInstance().requestLocationPermission(this);
        } else if (mGoogleMap != null) {
            if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
                    == PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION)
                    == PackageManager.PERMISSION_GRANTED) {
                mGoogleMap.setMyLocationEnabled(true);
            }

            new LocationUtils().enableLocation(this);
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        loadData();
    }

    @Override
    public boolean onMyLocationButtonClick() {

        return false;
    }


    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions,
                                           @NonNull int[] grantResults) {
        if (requestCode == PermissionUtils.REQUEST_LOCATION) {
            if(grantResults[0] == PackageManager.PERMISSION_DENIED ) {
                new DialogUtiils().showDialog(this, getString(R.string.location_denie), true);
            } else {
                new LocationUtils().enableLocation(this);
            }
        }
    }


    private Handler mHanlderGetMapShopCoupon = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            if(mListCoupons.size() > 0 && mListCoupons.get(mListCoupons.size() - 1) == null) {
                mListCoupons.remove(mListCoupons.size() - 1);
                mAdapterCoupon.notifyItemRemoved(mListCoupons.size());
            }
            switch (msg.what) {
                case APIConstants.HANDLER_REQUEST_SERVER_SUCCESS:
                    ResponseMapShopCouponData res = (ResponseMapShopCouponData) msg.obj;
                    if(res.code == APIConstants.REQUEST_OK && res.httpCode == APIConstants.HTTP_OK) {
                        mBuilderShopMarker = new LatLngBounds.Builder();
                        if(res.data != null && res.data.size() > 0) {
                            for (ResponseMapShopCoupon shop : res.data) {
                                addShopMarker(shop.getmId(), shop.getmShopName(), shop.getmAddress(), Double.parseDouble(shop.getmLatitude()), Double.parseDouble(shop.getmLongitude()));
//                                mHashMapOfShop.put(shop.getmId(), shop.getmLstCoupons());
                                mListCoupons.addAll(shop.getmLstCoupons());
                            }

//                            mAdapterCoupon.updateData(res.data.get(0).getmLstCoupons());
                            mPageTotal = res.pagination.getmPageTotal();
                            mAdapterCoupon.updateData(mListCoupons);
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
                    mScrollLoadMoreData.adjustCurrentPage();
                    new DialogUtiils().showDialog(mContext, getString(R.string.connection_failed), false);
                    break;
            }
            mScrollLoadMoreData.setLoaded();
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
