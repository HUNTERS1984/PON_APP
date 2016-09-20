package com.hunters1984.pon.activities;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.v4.app.ActivityCompat;
import android.support.v4.view.ViewPager;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.Button;
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
import com.hunters1984.pon.adapters.PhotoCouponPagerAdapter;
import com.hunters1984.pon.adapters.PhotoRecyclerViewAdapter;
import com.hunters1984.pon.models.CouponModel;
import com.hunters1984.pon.protocols.OnLoadDataListener;
import com.viewpagerindicator.CirclePageIndicator;

import java.util.ArrayList;
import java.util.List;

public class CouponDetailActivity extends AppCompatActivity implements OnMapReadyCallback,
        ActivityCompat.OnRequestPermissionsResultCallback, OnLoadDataListener {

    private GoogleMap mGoogleMap;
    protected List<CouponModel> mListCoupons;
    private List<String> mLstPhotos;

    private ViewPager mPagerCoupons;
    private CirclePageIndicator mPageIndicatorProduct;
    private int[] mListCouponPhotos =  {R.drawable.coupon_photo_1, R.drawable.coupon_photo_2};

    private boolean isFavourite = false;
    private Context mContext;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        mContext = this;
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

        ImageView ivBack = (ImageView)findViewById(R.id.iv_back);
        ivBack.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                onBackPressed();
            }
        });
        mPagerCoupons = (ViewPager)findViewById(R.id.pager_coupons_photo);
        PhotoCouponPagerAdapter photoAdapter = new PhotoCouponPagerAdapter(this, mListCouponPhotos);
        mPagerCoupons.setAdapter(photoAdapter);

        mPageIndicatorProduct = (CirclePageIndicator)findViewById(R.id.page_indicator_coupons_photo);
        mPageIndicatorProduct.setViewPager(mPagerCoupons);
        mPageIndicatorProduct.setFillColor(getResources().getColor(R.color.pink));
        mPageIndicatorProduct.setStrokeColor(getResources().getColor(R.color.grey));

        RecyclerView rvCoupons = (RecyclerView) findViewById(R.id.rv_list_related_coupons);
        GridLayoutManager layoutManager = new GridLayoutManager(this, 3);
        rvCoupons.setLayoutManager(layoutManager);
        PhotoRecyclerViewAdapter couponAdapter = new PhotoRecyclerViewAdapter(this, mLstPhotos, true);
        rvCoupons.setAdapter(couponAdapter);

        final FloatingActionButton btnShare = (FloatingActionButton)findViewById(R.id.fab_share);
        btnShare.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                mContext.startActivity(new Intent(mContext, ShareCouponActivity.class));
            }
        });

        final FloatingActionButton btnFavourite = (FloatingActionButton)findViewById(R.id.fab_add_favourite);
        btnFavourite.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                isFavourite = !isFavourite;
                if(isFavourite) {
                    btnFavourite.setImageResource(R.drawable.ic_favourite);
                } else {
                    btnFavourite.setImageResource(R.drawable.ic_non_favourite);
                }
            }
        });

        RecyclerView rv = (RecyclerView)findViewById(R.id.rv_list_coupons_other_shops);
        rv.setLayoutManager(new GridLayoutManager(this, 2));
        CouponRecyclerViewAdapter adapter = new CouponRecyclerViewAdapter(this, mListCoupons);
        rv.setAdapter(adapter);

        Button btnUseCoupons = (Button)findViewById(R.id.btn_use_coupon);
        btnUseCoupons.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(new Intent(mContext, UseCouponActivity.class));
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
