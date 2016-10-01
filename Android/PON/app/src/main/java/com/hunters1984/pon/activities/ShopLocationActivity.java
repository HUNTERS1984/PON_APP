package com.hunters1984.pon.activities;

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

import com.hunters1984.pon.R;
import com.hunters1984.pon.adapters.DividerItemDecoration;
import com.hunters1984.pon.adapters.ListCouponTypeRecyclerViewAdapter;
import com.hunters1984.pon.api.APIConstants;
import com.hunters1984.pon.api.CouponAPIHelper;
import com.hunters1984.pon.api.ResponseCouponTypeData;
import com.hunters1984.pon.models.CouponTypeModel;
import com.hunters1984.pon.utils.DialogUtiils;

import java.util.ArrayList;
import java.util.List;

public class ShopLocationActivity extends Activity {

    private List<CouponTypeModel> mLstCouponTypes;
    private ListCouponTypeRecyclerViewAdapter mAdapterCouponType;

    private Context mContext;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_shop_location);
        mContext = this;

        initData();

        RecyclerView rv = (RecyclerView)findViewById(R.id.rv_coupon_type);
        rv.setLayoutManager(new LinearLayoutManager(this));

        rv.addItemDecoration(new DividerItemDecoration(this, LinearLayoutManager.VERTICAL));
        rv.setItemAnimator(new DefaultItemAnimator());
        mAdapterCouponType = new ListCouponTypeRecyclerViewAdapter(this, mLstCouponTypes);
        rv.setAdapter(mAdapterCouponType);

        RelativeLayout rlShopLocation = (RelativeLayout)findViewById(R.id.rl_shop_location);
        rlShopLocation.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent iShopLocation = new Intent(ShopLocationActivity.this, MapShopCouponActivity.class);
                startActivity(iShopLocation);
            }
        });

    }

    private void initData()
    {
        mLstCouponTypes = new ArrayList<>();

        new CouponAPIHelper().getCouponType(mContext, "1", mHanlderGetCouponType);

//        for(int i=0; i<5; i++){
//            CouponTypeModel shop = new ShopModel();
//            switch (i)
//            {
//                case 0:
//                    shop.setmShopName("グルメ");
//                    break;
//                case 1:
//                    shop.setmShopName("ファッション");
//                    break;
//                case 2:
//                    shop.setmShopName("レジャー");
//                    break;
//                case 3:
//                    shop.setmShopName("グルメ");
//                    break;
//                case 4:
//                    shop.setmShopName("レジャー");
//                    break;
//            }
//            mLstCouponTypes.add(shop);
//        }
    }

    private Handler mHanlderGetCouponType = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case APIConstants.HANDLER_REQUEST_SERVER_SUCCESS:
                    ResponseCouponTypeData couponType = (ResponseCouponTypeData) msg.obj;
                    if (couponType.code == APIConstants.REQUEST_OK && couponType.httpCode == APIConstants.HTTP_OK) {
                        mAdapterCouponType.updateData(couponType.data);
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
