package com.hunters.pon.activities;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;

import com.hunters.pon.R;
import com.hunters.pon.adapters.SearchCouponRecyclerViewAdapter;
import com.hunters.pon.api.APIConstants;
import com.hunters.pon.api.CouponAPIHelper;
import com.hunters.pon.api.ResponseCouponDetail;
import com.hunters.pon.api.ResponseSearchCouponData;
import com.hunters.pon.protocols.OnLoadDataListener;
import com.hunters.pon.protocols.OnLoginClickListener;
import com.hunters.pon.utils.Constants;
import com.hunters.pon.utils.DialogUtiils;

import java.util.ArrayList;
import java.util.List;

public class SearchActivity extends BaseActivity implements OnLoadDataListener {

    private SearchCouponRecyclerViewAdapter mAdapterCoupon;

    private String mQuery = "";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        mContext = this;
        mDataListener = this;
        setContentView(R.layout.activity_search);
        mQuery = getIntent().getStringExtra(Constants.EXTRA_DATA);
        super.onCreate(savedInstanceState);

        setTitle(mQuery);

        RecyclerView rv = (RecyclerView)findViewById(R.id.recycler_search);
        rv.setLayoutManager(new GridLayoutManager(this, 2));

        List<ResponseCouponDetail> lstSearchCoupon = new ArrayList<>();
        mAdapterCoupon = new SearchCouponRecyclerViewAdapter(mContext, lstSearchCoupon, new OnLoginClickListener() {
            @Override
            public void onLoginClick() {
                startActivity(new Intent(mContext, SplashSelectLoginActivity.class));
            }
        });
        rv.setAdapter(mAdapterCoupon);
    }

    @Override
    public void onLoadData() {

        new CouponAPIHelper().searchCoupon(mContext, mQuery, "1", mHanlderSearchCoupon);

    }

    private Handler mHanlderSearchCoupon = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case APIConstants.HANDLER_REQUEST_SERVER_SUCCESS:
                    ResponseSearchCouponData couponData = (ResponseSearchCouponData) msg.obj;
                    if (couponData.code == APIConstants.REQUEST_OK && couponData.httpCode == APIConstants.HTTP_OK) {
                        if(couponData.data != null && couponData.data.size() > 0) {
                            mAdapterCoupon.updateData(couponData.data);
                        } else {
                            new DialogUtiils().showDialog(mContext, getString(R.string.no_record_found), true);
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
}
