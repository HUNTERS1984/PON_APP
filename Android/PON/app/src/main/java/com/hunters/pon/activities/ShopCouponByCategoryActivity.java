package com.hunters.pon.activities;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v7.widget.DefaultItemAnimator;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.RelativeLayout;

import com.hunters.pon.R;
import com.hunters.pon.adapters.CategoryRecyclerViewAdapter;
import com.hunters.pon.adapters.DividerItemDecoration;
import com.hunters.pon.api.APIConstants;
import com.hunters.pon.api.CouponAPIHelper;
import com.hunters.pon.api.ResponseCategoryData;
import com.hunters.pon.models.CategoryModel;
import com.hunters.pon.utils.DialogUtiils;

import java.util.ArrayList;
import java.util.List;

public class ShopCouponByCategoryActivity extends Activity {

    private List<CategoryModel> mLstCategories;
    private CategoryRecyclerViewAdapter mAdapterCategory;

    private Context mContext;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_shop_coupon_by_category);
        mContext = this;

        initData();

        RecyclerView rv = (RecyclerView)findViewById(R.id.rv_coupon_type);
        rv.setLayoutManager(new LinearLayoutManager(this));

        rv.addItemDecoration(new DividerItemDecoration(this, LinearLayoutManager.VERTICAL));
        rv.setItemAnimator(new DefaultItemAnimator());
        mAdapterCategory = new CategoryRecyclerViewAdapter(this, mLstCategories);
        rv.setAdapter(mAdapterCategory);

        RelativeLayout rlShopLocation = (RelativeLayout)findViewById(R.id.rl_shop_location);
        rlShopLocation.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent iShopLocation = new Intent(ShopCouponByCategoryActivity.this, MapShopCouponActivity.class);
                startActivity(iShopLocation);
            }
        });

    }

    private void initData()
    {
        mLstCategories = new ArrayList<>();

        new CouponAPIHelper().getCategory(mContext, "1", mHanlderGetCategory);


    }

    private Handler mHanlderGetCategory = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case APIConstants.HANDLER_REQUEST_SERVER_SUCCESS:
                    ResponseCategoryData couponType = (ResponseCategoryData) msg.obj;
                    if (couponType.code == APIConstants.REQUEST_OK && couponType.httpCode == APIConstants.HTTP_OK) {
                        mAdapterCategory.updateData(couponType.data);
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
