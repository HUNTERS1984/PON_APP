package com.hunters.pon.activities;

import android.app.Activity;
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
import com.hunters.pon.application.PonApplication;
import com.hunters.pon.customs.UseCouponDialog;
import com.hunters.pon.models.CouponModel;
import com.hunters.pon.models.ExtraDataModel;
import com.hunters.pon.protocols.OnDialogButtonConfirm;
import com.hunters.pon.protocols.OnLoadDataListener;
import com.hunters.pon.utils.CommonUtils;
import com.hunters.pon.utils.Constants;
import com.hunters.pon.utils.DialogUtiils;
import com.hunters.pon.utils.GoogleAnalyticUtils;
import com.squareup.picasso.Picasso;
import com.viewpagerindicator.CirclePageIndicator;

import java.util.ArrayList;
import java.util.List;

public class CouponDetailActivity extends AppCompatActivity implements OnMapReadyCallback,
        ActivityCompat.OnRequestPermissionsResultCallback, OnLoadDataListener {

    private static final int NUM_OF_PHOTO_VISIBLE = 8;
    private static final int USE_COUPON = 0;
    private static final int ADD_FAVOURITE = 1;

    private GoogleMap mGoogleMap;
    private List<CouponModel> mLstCoupons;
    private List<String> mLstCouponPhotos;
    private List<String> mLstVisibleCouponPhotos;

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
    private double mShopLng = 0.0, mShopLat = 0.0;
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
        mLstCoupons = new ArrayList<>();
        mLstVisibleCouponPhotos = new ArrayList<>();
        mLstCouponPhotos = new ArrayList<>();
        mLstUserPhotos = new ArrayList<>();

        initLayout();

        onLoadData();

        GoogleAnalyticUtils.getInstance(mContext).logScreenAccess((PonApplication)getApplication(), GoogleAnalyticUtils.COUPON_DETAIL_SCREEN);
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
        mCouponPhotoAdapter = new PhotoRecyclerViewAdapter(this, mLstVisibleCouponPhotos, mLstCouponPhotos, true);
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

                GoogleAnalyticUtils.getInstance(mContext).logEventLikeCoupon((PonApplication)((Activity)mContext).getApplication());
                mCurrentSelection = ADD_FAVOURITE;
                String token = CommonUtils.getToken(mContext);

                if(!token.equalsIgnoreCase("")) {
                    new UserProfileAPIHelper().checkValidToken(mContext, token, mHandlerCheckValidToken);
                } else {
                    ExtraDataModel data = new ExtraDataModel();
                    data.setmTitle(Constants.EXTRA_ADD_FAVOURITE);
                    data.setmId(mCouponId);
                    new DialogUtiils().showDialogLogin((Activity)mContext, getString(R.string.need_login), data);
                }

            }
        });

        mRvSimilarCoupons = (RecyclerView)findViewById(R.id.rv_list_coupons_other_shops);
        mRvSimilarCoupons.setLayoutManager(new GridLayoutManager(this, 2));
        mAdapterSimilarCoupon = new CouponRecyclerViewAdapter(this, mLstCoupons);
        mAdapterSimilarCoupon.enableFinishCurrentScreen();
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


//                Intent iUseCoupon = new Intent(mContext, UseCouponActivity.class);
//                iUseCoupon.putExtra(Constants.EXTRA_DATA, mCoupon.getmCode());
//                startActivity(iUseCoupon);
                GoogleAnalyticUtils.getInstance(mContext).logEventUseCoupon((PonApplication)((Activity)mContext).getApplication());
                mCurrentSelection = USE_COUPON;
                String token = CommonUtils.getToken(mContext);

                if(!token.equalsIgnoreCase("")) {
                    new UserProfileAPIHelper().checkValidToken(mContext, token, mHandlerCheckValidToken);
                } else {
                    ExtraDataModel data = new ExtraDataModel();
                    data.setmTitle(Constants.EXTRA_USE_COUPON);
                    data.setmId(mCouponId);
                    new DialogUtiils().showDialogLogin((Activity)mContext, getString(R.string.need_login), data);
                }
            }
        });
    }

    @Override
    protected void onResume() {
        super.onResume();
//        onLoadData();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if(requestCode == Constants.REQUEST_CODE_COUPON_DETAIL) {
            if (resultCode == Activity.RESULT_OK) {
                ExtraDataModel extra = (ExtraDataModel)data.getSerializableExtra(Constants.EXTRA_DATA);
                mCouponId = extra.getmId();
                onLoadData();
            }
        } else if(requestCode == Constants.REQUEST_CODE_ADD_FAVOURITE) {
            if (resultCode == Activity.RESULT_OK) {
                ExtraDataModel extra = (ExtraDataModel)data.getSerializableExtra(Constants.EXTRA_DATA);
                mCouponId = extra.getmId();
                new DialogUtiils().showOptionDialog(mContext, mContext.getString(R.string.confirm_like_coupon), mContext.getString(R.string.ok), mContext.getString(R.string.cancel), new OnDialogButtonConfirm(){

                    @Override
                    public void onDialogButtonConfirm() {
                        new CouponAPIHelper().addFavouriteCoupon(mContext, String.valueOf(mCouponId), mHanlderAddAndRemoveFavouriteCoupon);
                    }
                });

            }
        } else if(requestCode == Constants.REQUEST_CODE_USE_COUPON) {
            if (resultCode == Activity.RESULT_OK) {
                if(mCoupon != null) {
                    UseCouponDialog dialog = new UseCouponDialog(mContext, mCoupon.getmCode(), mHandlerUseCouponRequest);
                    dialog.show();
                }
            }
        }
    }

    @Override
    public void onMapReady(GoogleMap googleMap) {
        mGoogleMap = googleMap;
        mGoogleMap.setMapType(GoogleMap.MAP_TYPE_NORMAL);

        showShopMap(mShopLat, mShopLng);
    }

    @Override
    public void onLoadData() {

        mLstCoupons = new ArrayList<>();
        mLstVisibleCouponPhotos = new ArrayList<>();
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
                        mLstCoupons = new ArrayList<>();
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
                        mCoupon.setmFacebookLinkShare(coupon.getmFacebookLinkShare());
                        mCoupon.setmTwitterLinkShare(coupon.getmTwitterLinkShare());
                        mCoupon.setmInstagramLinkShare(coupon.getmInstagramLinkShare());
                        mCoupon.setmLineLinkShare(coupon.getmLineLinkShare());

                        List<String> lstCouponPhotos = coupon.getmLstPhotoCoupons();
                        if(lstCouponPhotos != null && lstCouponPhotos.size() > 0) {
                            mLstCouponPhotos.addAll(lstCouponPhotos);
                            if(lstCouponPhotos.size() > NUM_OF_PHOTO_VISIBLE) {
                                mLstVisibleCouponPhotos.addAll(lstCouponPhotos.subList(0, NUM_OF_PHOTO_VISIBLE + 1));
                                mCouponPhotoAdapter.updateData(mLstVisibleCouponPhotos, mLstCouponPhotos, true, String.valueOf(lstCouponPhotos.size() - NUM_OF_PHOTO_VISIBLE));
                            } else {
                                mLstVisibleCouponPhotos.addAll(lstCouponPhotos);
                                mCouponPhotoAdapter.updateData(mLstVisibleCouponPhotos, mLstCouponPhotos, false, "");
                            }

                        }

                        List<String> lstUserPhotos = coupon.getmLstPhotoUsers();
                        if(lstUserPhotos != null && lstUserPhotos.size() > 0) {
                            mLstUserPhotos.addAll(lstUserPhotos);
                            mUserPhotoPagerAdapter.updatePhotos(mLstUserPhotos);
                        }

                        mLstCoupons = coupon.getmLstSimilarCoupons();
                        if(mLstCoupons != null) {
                            mAdapterSimilarCoupon.updateData(mLstCoupons);
                        }

                        //Show/Hide button Use this coupon
                        if(coupon.getmCanUse() && coupon.getmCode() != null){
                            mBtnUseThisCoupon.setVisibility(View.VISIBLE);
                        } else {
                            mBtnUseThisCoupon.setVisibility(View.GONE);
                        }
                    } else if(data.httpCode == APIConstants.HTTP_UN_AUTHORIZATION) {
                        ExtraDataModel extra = new ExtraDataModel();
                        extra.setmTitle(Constants.EXTRA_VIEW_COUPON_DETAIL);
                        extra.setmId(mCouponId);
                        new DialogUtiils().showDialogLogin((Activity)mContext, getString(R.string.token_expried), extra);
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

    private Handler mHandlerCheckValidToken = new Handler(){
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
                                UseCouponDialog dialog = new UseCouponDialog(mContext, mCoupon.getmCode(), mHandlerUseCouponRequest);
                                dialog.show();
                                break;
                            case ADD_FAVOURITE:
                                if(isFavourite) {
                                    new DialogUtiils().showOptionDialog(mContext, mContext.getString(R.string.confirm_unlike_coupon), mContext.getString(R.string.ok), mContext.getString(R.string.cancel), new OnDialogButtonConfirm() {

                                        @Override
                                        public void onDialogButtonConfirm() {
                                            new CouponAPIHelper().removeFavouriteCoupon(mContext, String.valueOf(mCouponId), mHanlderAddAndRemoveFavouriteCoupon);
                                        }
                                    });
                                } else {
                                    new DialogUtiils().showOptionDialog(mContext, mContext.getString(R.string.confirm_like_coupon), mContext.getString(R.string.ok), mContext.getString(R.string.cancel), new OnDialogButtonConfirm() {

                                        @Override
                                        public void onDialogButtonConfirm() {
                                            new CouponAPIHelper().addFavouriteCoupon(mContext, String.valueOf(mCouponId), mHanlderAddAndRemoveFavouriteCoupon);
                                        }
                                    });
                                }
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

    private Handler mHandlerUseCouponRequest = new Handler() {
        @Override
        public void handleMessage(Message msg) {
//            String staffName = msg.obj.toString();
            if(mCoupon != null) {
                new CouponAPIHelper().requestUseCoupon(mContext, mCoupon.getmCode(), mHandlerUseCouponResponse);
            }
        }
    };

    private Handler mHandlerUseCouponResponse = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case APIConstants.HANDLER_REQUEST_SERVER_SUCCESS:
                    ResponseCommon data = (ResponseCommon) msg.obj;
                    if (data.code == APIConstants.REQUEST_OK && data.httpCode == APIConstants.HTTP_OK){
                        new DialogUtiils().showDialog(mContext, data.message, false);
                    } else if(data.httpCode == APIConstants.HTTP_UN_AUTHORIZATION) {
                        ExtraDataModel extra = new ExtraDataModel();
                        extra.setmTitle(Constants.EXTRA_USE_COUPON);
                        extra.setmId(mCouponId);
                        new DialogUtiils().showDialogLogin((Activity)mContext, getString(R.string.token_expried), extra);
                    }
                    break;
                case APIConstants.HANDLER_REQUEST_SERVER_FAILED:
                    new DialogUtiils().showDialog(mContext, getString(R.string.connection_failed), false);
                    break;
            }
        }
    };

    private Handler mHanlderAddAndRemoveFavouriteCoupon = new Handler(){
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
                        ExtraDataModel extra = new ExtraDataModel();
                        extra.setmTitle(Constants.EXTRA_ADD_FAVOURITE);
                        extra.setmId(mCouponId);
                        new DialogUtiils().showDialogLogin((Activity)mContext, getString(R.string.token_expried), extra);
                    } else {
                        if(data.message != null) {
                            new DialogUtiils().showDialog(mContext, data.message, false);
                        }
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
                fit().into(mIvCouponTypeIcon);
        Picasso.with(mContext)
                .load(coupon.getmShop().getmShopCat().getmIcon())
                .noFade()
                .fit().into(mIvShopCatIcon);
        mTvCouponTitle.setText(coupon.getmTitle());
        mTvCouponTypeid.setText(coupon.getmCouponType().getmName() + "・" + coupon.getmCouponId());
        mTvCouponExpireDate.setText(getString(R.string.deadline) + CommonUtils.convertDateFormat(coupon.getmExpireDate()));
        mTvCouponDescription.setText(coupon.getmDescription());
        mTvCouponAddress.setText(coupon.getmShop().getmAddress());
        mTvCouponOperationTime.setText(coupon.getmShop().getmOperationStartTime() + " - " + coupon.getmShop().getmOperationEndTime());
        mTvCouponPhone.setText(coupon.getmShop().getmPhone());


        isFavourite = coupon.getmIsFavourite();
        if(isFavourite) {
            mBtnFavourite.setImageResource(R.drawable.ic_favourite_floating_button);
        } else {
            mBtnFavourite.setImageResource(R.drawable.ic_non_favourite_floating_button);
        }

        String lat = coupon.getmShop().getmLatitude();
        String lng = coupon.getmShop().getmLongitude();
        if(lat != null && lng != null) {
            mShopLat = Double.parseDouble(lat);
            mShopLng = Double.parseDouble(lng);
        }
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
