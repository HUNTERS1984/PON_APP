package com.hunters.pon.activities;

import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;

import com.hunters.pon.R;
import com.hunters.pon.adapters.CouponRecyclerViewAdapter;
import com.hunters.pon.api.APIConstants;
import com.hunters.pon.api.CouponAPIHelper;
import com.hunters.pon.api.ResponseCommon;
import com.hunters.pon.api.ResponseMyFavourite;
import com.hunters.pon.api.ResponseMyFavouriteData;
import com.hunters.pon.api.UserProfileAPIHelper;
import com.hunters.pon.models.CouponModel;
import com.hunters.pon.protocols.OnLoadDataListener;
import com.hunters.pon.utils.CommonUtils;
import com.hunters.pon.utils.DialogUtiils;

import java.util.ArrayList;

public class MyFavouriteActivity extends BaseActivity implements OnLoadDataListener{

    private CouponRecyclerViewAdapter mAdapterCoupon;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        setContentView(R.layout.activity_my_favourite);
        mContext = this;
        mDataListener = this;
        super.onCreate(savedInstanceState);

        initLayout();
    }

    @Override
    public void onLoadData() {
        mListCoupons = new ArrayList<>();

        String token = CommonUtils.getToken(mContext);

        if(!token.equalsIgnoreCase("")) {
            new UserProfileAPIHelper().checkValidToken(mContext, token, mHanlderCheckValidToken);
        }
    }

    private void initLayout()
    {
        setTitle(getString(R.string.favourite));
        setIconBack(R.drawable.ic_add);

        activeMyFavourite();

        RecyclerView rv = (RecyclerView)findViewById(R.id.recycler_view_my_favourite);
        rv.setLayoutManager(new GridLayoutManager(this, 2));

        mAdapterCoupon = new CouponRecyclerViewAdapter(this, mListCoupons);
        rv.setAdapter(mAdapterCoupon);
    }

    private Handler mHanlderCheckValidToken = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case APIConstants.HANDLER_REQUEST_SERVER_SUCCESS:
                    ResponseCommon res = (ResponseCommon) msg.obj;
                    if(res.httpCode == APIConstants.HTTP_UN_AUTHORIZATION) {
                        CommonUtils.saveToken(mContext, "");
                        checkToUpdateButtonLogin();
                        new DialogUtiils().showDialog(mContext, getString(R.string.token_expried), true);
                    } else if (res.httpCode == APIConstants.HTTP_OK && res.code == APIConstants.REQUEST_OK) {
                        new CouponAPIHelper().getFavouriteCoupon(mContext, "1", mHanlderFavouriteCoupon);
                    }
                    break;
                case APIConstants.HANDLER_REQUEST_SERVER_FAILED:
                    new DialogUtiils().showDialog(mContext, getString(R.string.connection_failed), true);
                    break;
            }
        }
    };

    private Handler mHanlderFavouriteCoupon = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case APIConstants.HANDLER_REQUEST_SERVER_SUCCESS:
                    ResponseMyFavouriteData couponData = (ResponseMyFavouriteData) msg.obj;
                    if (couponData.code == APIConstants.REQUEST_OK && couponData.httpCode == APIConstants.HTTP_OK) {
                        for(ResponseMyFavourite coupon : couponData.data) {
                            CouponModel model = new CouponModel();
                            model.setmIsFavourite(coupon.getmIsFavourite());
                            model.setmTitle(coupon.getmTitle());
                            model.setmImageUrl(coupon.getmImageUrl());
                            model.setmExpireDate(coupon.getmExpireDate());
                            model.setmCanUse(coupon.getmCanUse());
                            model.setmCouponType(coupon.getmCouponType());
                            model.setmIsLoginRequired(coupon.getmIsLoginRequired());
                            mListCoupons.add(model);
                        }
                        mAdapterCoupon.updateData(mListCoupons);
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
}
