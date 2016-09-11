package com.hunters1984.pon.activities;

import android.os.Bundle;
import android.support.v4.app.ActivityCompat;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;

import com.google.android.gms.maps.CameraUpdate;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.MapFragment;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.MarkerOptions;
import com.hunters1984.pon.R;
import com.hunters1984.pon.adapters.RelatedCouponRecyclerViewAdapter;
import com.hunters1984.pon.models.CouponModel;
import com.hunters1984.pon.protocols.OnLoadDataListener;

import java.util.ArrayList;
import java.util.List;

public class CouponDetailActivity extends AppCompatActivity implements OnMapReadyCallback,
        ActivityCompat.OnRequestPermissionsResultCallback, OnLoadDataListener {

    private GoogleMap mGoogleMap;
    protected List<CouponModel> mListCoupons;

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_coupon_detail);

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

        RecyclerView rvCoupons = (RecyclerView) findViewById(R.id.rv_list_related_coupons);
        GridLayoutManager layoutManager = new GridLayoutManager(this, 3);
        rvCoupons.setLayoutManager(layoutManager);
        RelatedCouponRecyclerViewAdapter adapter = new RelatedCouponRecyclerViewAdapter(this, mListCoupons);
        rvCoupons.setAdapter(adapter);
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
            coupon.setmTitle("Title");
            coupon.setmDescription("Description");
            coupon.setmExpireDate("Expire : 2016.2.7");
            coupon.setmIsFavourite((i%2==0?true:false));
            coupon.setmIsLoginRequired((i%2==0?true:false));
            mListCoupons.add(coupon);
        }
    }
}
