package com.hunters1984.pon.activities;

import android.os.Bundle;
import android.support.v4.app.ActivityCompat;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;

import com.google.android.gms.maps.CameraUpdate;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.MapFragment;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.MarkerOptions;
import com.hunters1984.pon.R;
import com.hunters1984.pon.adapters.CouponRecyclerViewAdapter;
import com.hunters1984.pon.adapters.PhotoRecyclerViewAdapter;
import com.hunters1984.pon.models.CouponModel;
import com.hunters1984.pon.protocols.OnLoadDataListener;

import java.util.ArrayList;
import java.util.List;

public class ShopDetailActivity extends AppCompatActivity implements OnLoadDataListener, OnMapReadyCallback,
        ActivityCompat.OnRequestPermissionsResultCallback {

    private List<String> mLstPhotos;
    private List<CouponModel> mListCoupons;

    private GoogleMap mGoogleMap;

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_shop_detail);
        onLoadData();

        initLayout();

    }

    private void initLayout()
    {
        try {
            if (mGoogleMap == null) {
                ((MapFragment) getFragmentManager().
                        findFragmentById(R.id.map_shop)).getMapAsync(this);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        RecyclerView rvCoupons = (RecyclerView) findViewById(R.id.recycler_view_coupons_of_shop);
        LinearLayoutManager lmCoupons = new LinearLayoutManager(this);
        lmCoupons.setOrientation(LinearLayoutManager.HORIZONTAL);
        rvCoupons.setLayoutManager(lmCoupons);
        CouponRecyclerViewAdapter adapter = new CouponRecyclerViewAdapter(this, mListCoupons);
        rvCoupons.setAdapter(adapter);

        RecyclerView rvPhotoShops = (RecyclerView) findViewById(R.id.recycler_view_photo_of_shop);
        GridLayoutManager lmShop = new GridLayoutManager(this, 3);
        rvPhotoShops.setLayoutManager(lmShop);
        PhotoRecyclerViewAdapter couponAdapter = new PhotoRecyclerViewAdapter(this, mLstPhotos, false);
        rvPhotoShops.setAdapter(couponAdapter);

        ImageView ivBack = (ImageView)findViewById(R.id.iv_back);
        ivBack.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                onBackPressed();
            }
        });

    }

    @Override
    public void onMapReady(GoogleMap googleMap) {
        mGoogleMap = googleMap;
        mGoogleMap.setMapType(GoogleMap.MAP_TYPE_NORMAL);

        LatLng shopLoc = new LatLng(10.827121, 106.636691);
        CameraUpdate camera = CameraUpdateFactory.newLatLngZoom(shopLoc, 15);
        mGoogleMap.animateCamera(camera);

        mGoogleMap.addMarker(new MarkerOptions().position(shopLoc));
    }

    @Override
    public void onLoadData() {
        mListCoupons = new ArrayList<>();
        for(int i=0; i<5; i++) {
            CouponModel coupon = new CouponModel();
            coupon.setmTitle("タイトルが入ります");
            coupon.setmDescription("タイプが入ります");
            coupon.setmExpireDate("期限：2016.07.31");
            coupon.setmIsFavourite((i%2==0?true:false));
            coupon.setmIsLoginRequired((i%2==0?true:false));
            mListCoupons.add(coupon);
        }

        mLstPhotos = new ArrayList<>();
        mLstPhotos.add("url1");
        mLstPhotos.add("url1");
        mLstPhotos.add("url1");
        mLstPhotos.add("url1");
        mLstPhotos.add("url1");
        mLstPhotos.add("url1");
    }
}
