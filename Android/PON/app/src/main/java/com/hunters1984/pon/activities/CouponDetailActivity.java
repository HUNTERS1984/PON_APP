package com.hunters1984.pon.activities;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.design.widget.FloatingActionButton;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.support.v4.view.ViewPager;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

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
import com.hunters1984.pon.api.APIConstants;
import com.hunters1984.pon.api.CouponAPIHelper;
import com.hunters1984.pon.api.ResponseCouponDetail;
import com.hunters1984.pon.api.ResponseCouponDetailData;
import com.hunters1984.pon.models.CouponModel;
import com.hunters1984.pon.protocols.OnLoadDataListener;
import com.hunters1984.pon.utils.CommonUtils;
import com.hunters1984.pon.utils.Constants;
import com.hunters1984.pon.utils.DialogUtiils;
import com.squareup.picasso.Picasso;
import com.viewpagerindicator.CirclePageIndicator;

import java.util.ArrayList;
import java.util.List;

public class CouponDetailActivity extends AppCompatActivity implements OnMapReadyCallback,
        ActivityCompat.OnRequestPermissionsResultCallback, OnLoadDataListener {

    private GoogleMap mGoogleMap;
    protected List<CouponModel> mListCoupons;
    private List<String> mLstCouponPhotos;

    private TextView mTvCouponTitle, mTvCouponTypeid, mTvCouponDescription, mTvCouponExpireDate, mTvCouponAddress,
                     mTvCouponOperationTime, mTvCouponPhone, mTvCouponType;
    private ImageView mIvCouponTypeIcon;

    private RecyclerView mRvSimilarCoupons;
    private CouponRecyclerViewAdapter mAdapterSimilarCoupon;
    private FloatingActionButton mBtnShare, mBtnFavourite;
    private PhotoCouponPagerAdapter mUserPhotoPagerAdapter;
    private PhotoRecyclerViewAdapter mCouponPhotoAdapter;
    private Button mBtnUseThisCoupon;

    private ViewPager mPagerCoupons;
    private CirclePageIndicator mPageIndicatorProduct;
    private List<String> mLstUserPhotos;

    private boolean isFavourite = false;
    private double mShopLng, mShopLat;
    private Context mContext;
    private double mCouponId;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        mContext = this;
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_coupon_detail);

        mCouponId = getIntent().getDoubleExtra(Constants.EXTRA_COUPON_ID, 0);

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

        mTvCouponType = (TextView)findViewById(R.id.tv_coupon_type);
        mIvCouponTypeIcon = (ImageView)findViewById(R.id.iv_coupon_type_icon);
        mTvCouponTitle = (TextView)findViewById(R.id.tv_coupon_title);
        mTvCouponTypeid = (TextView)findViewById(R.id.tv_coupon_type_id);
        mTvCouponExpireDate = (TextView)findViewById(R.id.tv_coupon_expire_date);
        mTvCouponDescription = (TextView)findViewById(R.id.tv_coupon_description);
        mTvCouponAddress = (TextView)findViewById(R.id.tv_coupon_address);
        mTvCouponOperationTime = (TextView)findViewById(R.id.tv_coupon_opearation_time);
        mTvCouponPhone = (TextView)findViewById(R.id.tv_coupon_phone);

        ImageView ivBack = (ImageView)findViewById(R.id.iv_back);
        ivBack.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                onBackPressed();
            }
        });
        mPagerCoupons = (ViewPager)findViewById(R.id.pager_coupons_photo);
        mUserPhotoPagerAdapter = new PhotoCouponPagerAdapter(this, mLstUserPhotos);
        mPagerCoupons.setAdapter(mUserPhotoPagerAdapter);

        mPageIndicatorProduct = (CirclePageIndicator)findViewById(R.id.page_indicator_coupons_photo);
        mPageIndicatorProduct.setViewPager(mPagerCoupons);
        mPageIndicatorProduct.setFillColor(ContextCompat.getColor(mContext, R.color.blue_sky));
        mPageIndicatorProduct.setStrokeColor(ContextCompat.getColor(mContext, R.color.grey));

        RecyclerView rvCoupons = (RecyclerView) findViewById(R.id.rv_list_related_coupons);
        GridLayoutManager layoutManager = new GridLayoutManager(this, 3);
        rvCoupons.setLayoutManager(layoutManager);
        mCouponPhotoAdapter = new PhotoRecyclerViewAdapter(this, mLstCouponPhotos, true);
        rvCoupons.setAdapter(mCouponPhotoAdapter);

        mBtnShare = (FloatingActionButton)findViewById(R.id.fab_share);
        mBtnShare.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                mContext.startActivity(new Intent(mContext, ShareCouponActivity.class));
            }
        });

        mBtnFavourite = (FloatingActionButton)findViewById(R.id.fab_add_favourite);
        mBtnFavourite.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                isFavourite = !isFavourite;
                if(isFavourite) {
                    mBtnFavourite.setImageResource(R.drawable.ic_favourite_floating_button);
                } else {
                    mBtnFavourite.setImageResource(R.drawable.ic_non_favourite_floating_button);
                }
            }
        });

        mRvSimilarCoupons = (RecyclerView)findViewById(R.id.rv_list_coupons_other_shops);
        mRvSimilarCoupons.setLayoutManager(new GridLayoutManager(this, 2));
        mAdapterSimilarCoupon = new CouponRecyclerViewAdapter(this, mListCoupons);
        mRvSimilarCoupons.setAdapter(mAdapterSimilarCoupon);

        Button btnUseCoupons = (Button)findViewById(R.id.btn_qr_code_coupon);
        btnUseCoupons.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(new Intent(mContext, UseCouponActivity.class));
            }
        });

        mBtnUseThisCoupon = (Button)findViewById(R.id.btn_use_this_coupon);
        mBtnUseThisCoupon.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

            }
        });
    }

    @Override
    public void onMapReady(GoogleMap googleMap) {
        mGoogleMap = googleMap;
        mGoogleMap.setMapType(GoogleMap.MAP_TYPE_NORMAL);

        showShopMap(mShopLat, mShopLng);
    }

    @Override
    public void onLoadData() {
        mListCoupons = new ArrayList<>();
        mLstCouponPhotos = new ArrayList<>();
        mLstUserPhotos = new ArrayList<>();
        new CouponAPIHelper().getCouponDetail(mContext, mCouponId, mHanlderCouponDetail);
    }

    private Handler mHanlderCouponDetail = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case APIConstants.HANDLER_REQUEST_SERVER_SUCCESS:
                    ResponseCouponDetailData data = (ResponseCouponDetailData) msg.obj;
                    if (data.code == APIConstants.REQUEST_OK && data.httpCode == APIConstants.HTTP_OK) {
                        ResponseCouponDetail coupon = data.data;
                        popularLayout(coupon);

                        String type = coupon.getmCouponType().getmName();
                        for(CouponModel model : coupon.getmLstSimilarCoupons()) {
                            model.setmType(type);
                            mListCoupons.add(model);
                        }

                        List<String> lstCouponPhotos = coupon.getmLstPhotoCoupons();
                        if(lstCouponPhotos != null && lstCouponPhotos.size() > 0) {
                            if(lstCouponPhotos.size() > 8) {
                                mLstCouponPhotos.addAll(lstCouponPhotos.subList(0, 9));
                                mCouponPhotoAdapter.updateData(mLstCouponPhotos, true, String.valueOf(lstCouponPhotos.size() - 8));
                            } else {
                                mLstCouponPhotos.addAll(lstCouponPhotos);
                                mCouponPhotoAdapter.updateData(mLstCouponPhotos, false, "");
                            }
                        }

                        List<String> lstUserPhotos = coupon.getmLstPhotoUsers();
                        if(lstUserPhotos != null && lstUserPhotos.size() > 0) {
                            mLstUserPhotos.addAll(lstUserPhotos);
                            mUserPhotoPagerAdapter.updatePhotos(mLstUserPhotos);
                        }

                        mAdapterSimilarCoupon.updateData(mListCoupons);

                        //Show/Hide button Use this coupon
                        if(CommonUtils.convertBoolean(coupon.getmCanUse())){
                            mBtnUseThisCoupon.setVisibility(View.VISIBLE);
                        } else {
                            mBtnUseThisCoupon.setVisibility(View.GONE);
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

    private void popularLayout(ResponseCouponDetail coupon)
    {
        mTvCouponType.setText(coupon.getmCouponType().getmName());
        Picasso.with(mContext).load(coupon.getmCouponType().getmIcon()).
                resize(CommonUtils.dpToPx(mContext, 20), CommonUtils.dpToPx(mContext, 20)).into(mIvCouponTypeIcon);
        mTvCouponTitle.setText(coupon.getmTitle());
        mTvCouponTypeid.setText(coupon.getmCouponType().getmName() + "・" + coupon.getmId());
        mTvCouponExpireDate.setText(getString(R.string.deadline) + CommonUtils.convertDateFormat(coupon.getmExpireDate()));
        mTvCouponDescription.setText(coupon.getmDescription());
        mTvCouponAddress.setText(coupon.getmShop().getmAddress());
        mTvCouponOperationTime.setText(coupon.getmShop().getmOperationStartTime() + " - " + coupon.getmShop().getmOperationEndTime());
        mTvCouponPhone.setText(coupon.getmShop().getmPhone());


        boolean isFavourite = CommonUtils.convertBoolean(coupon.getmIsFavourite());
        if(isFavourite) {
            mBtnFavourite.setImageResource(R.drawable.ic_favourite_floating_button);
        } else {
            mBtnFavourite.setImageResource(R.drawable.ic_non_favourite_floating_button);
        }

        mShopLat = Double.parseDouble(coupon.getmShop().getmLatitude().toString());
        mShopLng = Double.parseDouble(coupon.getmShop().getmLongitude().toString());
        showShopMap(mShopLat, mShopLng);
    }

    private void showShopMap(double lat, double lng)
    {
        if (mGoogleMap != null) {
            LatLng shopLoc = new LatLng(lat, lng);
            CameraUpdate camera = CameraUpdateFactory.newLatLngZoom(shopLoc, 10);
            mGoogleMap.moveCamera(camera);
            mGoogleMap.addMarker(new MarkerOptions().position(shopLoc));
        }
    }
}
