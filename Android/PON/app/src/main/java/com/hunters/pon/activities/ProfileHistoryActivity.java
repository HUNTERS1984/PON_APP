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
import com.hunters.pon.api.ResponseHistoryCoupon;
import com.hunters.pon.api.ResponseHistoryCouponData;
import com.hunters.pon.api.UserProfileAPIHelper;
import com.hunters.pon.customs.EndlessRecyclerViewScrollListener;
import com.hunters.pon.models.CouponModel;
import com.hunters.pon.protocols.OnLoadDataListener;
import com.hunters.pon.utils.CommonUtils;
import com.hunters.pon.utils.Constants;
import com.hunters.pon.utils.DialogUtiils;

import java.util.ArrayList;

public class ProfileHistoryActivity extends BaseActivity implements OnLoadDataListener {

    private CouponRecyclerViewAdapter mAdapterCoupon;
    private EndlessRecyclerViewScrollListener mScrollLoadMoreData;
    private int mPageTotal;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        mContext = this;
        mDataListener = this;
        setContentView(R.layout.activity_history);
        super.onCreate(savedInstanceState);
        setTitle(getResources().getString(R.string.history));

        RecyclerView rv = (RecyclerView)findViewById(R.id.recycler_view_history);
        GridLayoutManager layoutManager = new GridLayoutManager(this, 2);
        rv.setLayoutManager(layoutManager);

        mScrollLoadMoreData = new EndlessRecyclerViewScrollListener(layoutManager) {
            @Override
            public void onLoadMore(int page, int totalItemsCount) {
                if(page < mPageTotal) {
                    mListCoupons.add(null);
                    mAdapterCoupon.notifyItemInserted(mListCoupons.size() - 1);
                    new CouponAPIHelper().getHistoryCoupon(mContext, String.valueOf(page + 1), mHanlderHistoryCoupon, false);
                }
            }
        };

        layoutManager.setSpanSizeLookup(new GridLayoutManager.SpanSizeLookup() {
            @Override
            public int getSpanSize(int position) {
                switch(mAdapterCoupon.getItemViewType(position)){
                    case Constants.VIEW_TYPE_ITEM:
                        return 1;
                    case Constants.VIEW_TYPE_LOADING:
                        return 2; //number of columns of the grid
                    default:
                        return -1;
                }
            }
        });
        rv.addOnScrollListener(mScrollLoadMoreData);

        mAdapterCoupon = new CouponRecyclerViewAdapter(this, mListCoupons);
        rv.setAdapter(mAdapterCoupon);
    }

    @Override
    public void onLoadData() {
        mListCoupons = new ArrayList<>();

        String token = CommonUtils.getToken(mContext);

        if(!token.equalsIgnoreCase("")) {
            new UserProfileAPIHelper().checkValidToken(mContext, token, mHanlderCheckValidToken);
        }

//        for(int i=0; i<5; i++) {
//            CouponModel coupon = new CouponModel();
//            coupon.setmTitle("タイトルが入ります");
//            coupon.setmExpireDate("2016-09-27T15:37:46+0000");
//            coupon.setmIsFavourite((i%2==0?1:0));
//            coupon.setmIsLoginRequired((i%2==0?1:0));
//            mListCoupons.add(coupon);
//        }
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
                        new CouponAPIHelper().getHistoryCoupon(mContext, "1", mHanlderHistoryCoupon, true);
                    }
                    break;
                case APIConstants.HANDLER_REQUEST_SERVER_FAILED:
                    new DialogUtiils().showDialog(mContext, getString(R.string.connection_failed), true);
                    break;
            }
        }
    };

    private Handler mHanlderHistoryCoupon = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            if(mListCoupons.size() > 0 && mListCoupons.get(mListCoupons.size() - 1) == null) {
                mListCoupons.remove(mListCoupons.size() - 1);
                mAdapterCoupon.notifyItemRemoved(mListCoupons.size());
            }
            switch (msg.what) {
                case APIConstants.HANDLER_REQUEST_SERVER_SUCCESS:
                    ResponseHistoryCouponData couponData = (ResponseHistoryCouponData) msg.obj;
                    if (couponData.code == APIConstants.REQUEST_OK && couponData.httpCode == APIConstants.HTTP_OK) {
                        for(ResponseHistoryCoupon coupon : couponData.data) {
                            CouponModel model = new CouponModel();
                            model.setmIsFavourite(coupon.getmIsFavourite());
                            model.setmTitle(coupon.getmTitle());
                            model.setmImageUrl(coupon.getmImageUrl());
                            model.setmExpireDate(coupon.getmExpireDate());
                            model.setmCanUse(coupon.getmCanUse());
                            model.setmCouponType(coupon.getmCouponType());
                            model.setmIsLoginRequired(coupon.getmIsLoginRequired());
                            model.setmIsUsed(true);
                            mListCoupons.add(model);
                        }
                        mPageTotal = couponData.pagination.getmPageTotal();
                        mAdapterCoupon.updateData(mListCoupons);
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
}
