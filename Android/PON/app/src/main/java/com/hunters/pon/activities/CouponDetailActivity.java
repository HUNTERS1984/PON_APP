package com.hunters.pon.activities;

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
import com.hunters.pon.R;
import com.hunters.pon.adapters.CouponRecyclerViewAdapter;
import com.hunters.pon.adapters.PhotoCouponPagerAdapter;
import com.hunters.pon.adapters.PhotoRecyclerViewAdapter;
import com.hunters.pon.api.APIConstants;
import com.hunters.pon.api.CouponAPIHelper;
import com.hunters.pon.api.ResponseCommon;
import com.hunters.pon.api.ResponseCouponDetail;
import com.hunters.pon.api.ResponseCouponDetailData;
import com.hunters.pon.api.UserProfileAPIHelper;
import com.hunters.pon.models.CouponModel;
import com.hunters.pon.protocols.OnLoadDataListener;
import com.hunters.pon.utils.CommonUtils;
import com.hunters.pon.utils.Constants;
import com.hunters.pon.utils.DialogUtiils;
import com.squareup.picasso.Picasso;
import com.viewpagerindicator.CirclePageIndicator;

import java.util.ArrayList;
import java.util.List;

public class CouponDetailActivity extends AppCompatActivity implements OnMapReadyCallback,
        ActivityCompat.OnRequestPermissionsResultCallback, OnLoadDataListener {

    private static final int USE_COUPON = 0;
    private static final int ADD_FAVOURITE = 1;

    private GoogleMap mGoogleMap;
    protected List<CouponModel> mListCoupons;
    private List<String> mLstCouponPhotos;

    private TextView mTvCouponTitle, mTvCouponTypeid, mTvCouponDescription, mTvCouponExpireDate, mTvCouponAddress,
                     mTvCouponOperationTime, mTvCouponPhone, mTvCouponType;
    private ImageView mIvCouponTypeIcon, mIvShopCatIcon;

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
    private long mCouponId;
    private CouponModel mCoupon;
    private int mCurrentSelection;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        mContext = this;
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_coupon_detail);

        mCouponId = getIntent().getLongExtra(Constants.EXTRA_COUPON_ID, 0);

//        onLoadData();
        mListCoupons = new ArrayList<>();
        mLstCouponPhotos = new ArrayList<>();
        mLstUserPhotos = new ArrayList<>();

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
        mIvShopCatIcon = (ImageView)findViewById(R.id.iv_shop_cat);
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
                Intent iShareCoupon = new Intent(mContext, ShareCouponActivity.class);
                iShareCoupon.putExtra(Constants.EXTRA_DATA, mCoupon);
                mContext.startActivity(iShareCoupon);
            }
        });

        mBtnFavourite = (FloatingActionButton)findViewById(R.id.fab_add_favourite);
        mBtnFavourite.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                mCurrentSelection = ADD_FAVOURITE;
                String token = CommonUtils.getToken(mContext);

                if(!token.equalsIgnoreCase("")) {
                    new UserProfileAPIHelper().checkValidToken(mContext, token, mHanlderCheckValidToken);
                } else {
                    new DialogUtiils().showDialog(mContext, getString(R.string.need_login), false);
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
                Intent iUseCoupon = new Intent(mContext, UseCouponActivity.class);
                iUseCoupon.putExtra(Constants.EXTRA_DATA, mCoupon.getmCode());
                startActivity(iUseCoupon);
            }
        });

        mBtnUseThisCoupon = (Button)findViewById(R.id.btn_use_this_coupon);
        mBtnUseThisCoupon.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                mCurrentSelection = USE_COUPON;
                String token = CommonUtils.getToken(mContext);

                if(!token.equalsIgnoreCase("")) {
                    new UserProfileAPIHelper().checkValidToken(mContext, token, mHanlderCheckValidToken);
                } else {
                    new DialogUtiils().showDialog(mContext, getString(R.string.need_login), false);
                }
            }
        });
    }

    @Override
    protected void onResume() {
        super.onResume();
        onLoadData();
    }

    @Override
    public void onMapReady(GoogleMap googleMap) {
        mGoogleMap = googleMap;
        mGoogleMap.setMapType(GoogleMap.MAP_TYPE_NORMAL);

        showShopMap(mShopLat, mShopLng);
    }

    @Override
    public void onLoadData() {

        new CouponAPIHelper().getCouponDetail(mContext, mCouponId, mHanlderCouponDetail);
    }

    private Handler mHanlderCouponDetail = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case APIConstants.HANDLER_REQUEST_SERVER_SUCCESS:
                    ResponseCouponDetailData data = (ResponseCouponDetailData) msg.obj;
                    if (data.code == APIConstants.REQUEST_OK && data.httpCode == APIConstants.HTTP_OK) {
                        mListCoupons = new ArrayList<>();
                        mLstCouponPhotos = new ArrayList<>();
                        mLstUserPhotos = new ArrayList<>();

                        ResponseCouponDetail coupon = data.data;
                        popularLayout(coupon);

                        mCoupon = new CouponModel();
                        mCoupon.setmId(coupon.getmId());
                        mCoupon.setmTitle(coupon.getmTitle());
                        mCoupon.setmImageUrl(coupon.getmImageUrl());
                        mCoupon.setmCode(coupon.getmCode());
                        mCoupon.setmDescription(coupon.getmDescription());

                        mListCoupons = coupon.getmLstSimilarCoupons();

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
                    } else if(data.httpCode == APIConstants.HTTP_UN_AUTHORIZATION) {
                        new DialogUtiils().showDialogLogin(mContext, getString(R.string.token_expried));
                    } else {
                        new DialogUtiils().showDialog(mContext, getString(R.string.server_error), true);
                    }
                    break;
                case APIConstants.HANDLER_REQUEST_SERVER_FAILED:
                    new DialogUtiils().showDialog(mContext, getString(R.string.connection_failed), true);
                    break;
            }
        }
    };

    private Handler mHanlderCheckValidToken = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case APIConstants.HANDLER_REQUEST_SERVER_SUCCESS:
                    ResponseCommon res = (ResponseCommon) msg.obj;
                    if(res.httpCode == APIConstants.HTTP_UN_AUTHORIZATION) {
                        CommonUtils.saveToken(mContext, "");
                        new DialogUtiils().showDialog(mContext, getString(R.string.token_expried), true);
                    } else if (res.httpCode == APIConstants.HTTP_OK && res.code == APIConstants.REQUEST_OK) {
                        switch (mCurrentSelection){
                            case USE_COUPON:
                                new CouponAPIHelper().useCoupon(mContext, mCouponId, mHanlderUseCoupon);
                                break;
                            case ADD_FAVOURITE:
                                new CouponAPIHelper().addFavouriteCoupon(mContext, String.valueOf(mCouponId), mHanlderAddFavouriteCoupon);
                                break;
                        }

                    }
                    break;
                case APIConstants.HANDLER_REQUEST_SERVER_FAILED:
                    new DialogUtiils().showDialog(mContext, getString(R.string.connection_failed), false);
                    break;
            }
        }
    };

    private Handler mHanlderUseCoupon = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case APIConstants.HANDLER_REQUEST_SERVER_SUCCESS:
                    ResponseCommon data = (ResponseCommon) msg.obj;
                    if (data.code == APIConstants.REQUEST_OK && data.httpCode == APIConstants.HTTP_OK){
                        new DialogUtiils().showDialog(mContext, data.message, false);
                    } else if(data.httpCode == APIConstants.HTTP_UN_AUTHORIZATION) {
                        new DialogUtiils().showDialogLogin(mContext, getString(R.string.token_expried));
                    }
                    break;
                case APIConstants.HANDLER_REQUEST_SERVER_FAILED:
                    new DialogUtiils().showDialog(mContext, getString(R.string.connection_failed), false);
                    break;
            }
        }
    };

    private Handler mHanlderAddFavouriteCoupon = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case APIConstants.HANDLER_REQUEST_SERVER_SUCCESS:
                    ResponseCommon data = (ResponseCommon) msg.obj;
                    if (data.code == APIConstants.REQUEST_OK && data.httpCode == APIConstants.HTTP_OK){
                        isFavourite = !isFavourite;
                        if(isFavourite) {
                            mBtnFavourite.setImageResource(R.drawable.ic_favourite_floating_button);
                        } else {
                            mBtnFavourite.setImageResource(R.drawable.ic_non_favourite_floating_button);
                        }
                        new DialogUtiils().showDialog(mContext, data.message, false);
                    } else if(data.httpCode == APIConstants.HTTP_UN_AUTHORIZATION) {
                        new DialogUtiils().showDialogLogin(mContext, getString(R.string.token_expried));
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
        Picasso.with(mContext).load(coupon.getmImageUrl()).
                resize(CommonUtils.dpToPx(mContext, 20), CommonUtils.dpToPx(mContext, 20)).into(mIvCouponTypeIcon);
        Picasso.with(mContext).load(coupon.getmShop().getmShopCat().getmIcon()).
                resize(CommonUtils.dpToPx(mContext, 60), CommonUtils.dpToPx(mContext, 60)).into(mIvShopCatIcon);
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
