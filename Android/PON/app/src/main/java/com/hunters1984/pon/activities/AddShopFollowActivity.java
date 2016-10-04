package com.hunters1984.pon.activities;

import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v7.widget.DefaultItemAnimator;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;

import com.hunters1984.pon.R;
import com.hunters1984.pon.adapters.CouponTypeShopFollowRecyclerViewAdapter;
import com.hunters1984.pon.adapters.DividerItemDecoration;
import com.hunters1984.pon.api.APIConstants;
import com.hunters1984.pon.api.CouponAPIHelper;
import com.hunters1984.pon.api.ResponseCategoryShopFollowData;
import com.hunters1984.pon.models.CategoryShopFollowModel;
import com.hunters1984.pon.protocols.OnLoadDataListener;
import com.hunters1984.pon.utils.DialogUtiils;

import java.util.ArrayList;
import java.util.List;

public class AddShopFollowActivity extends BaseActivity implements OnLoadDataListener {

    private List<CategoryShopFollowModel> mLstCouponTypeShopFollow;
    private CouponTypeShopFollowRecyclerViewAdapter mAdapterCouponTypeShopFollow;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        setContentView(R.layout.activity_coupon_type_shop_follow);
        mContext = this;
        mDataListener = this;
        super.onCreate(savedInstanceState);

        initLayout();

    }

    private void initLayout()
    {
        setTitle(getString(R.string.add_shop));
        setIconBack(R.drawable.ic_close);

        RecyclerView rv = (RecyclerView)findViewById(R.id.rv_shop_subscribe);
        rv.setLayoutManager(new LinearLayoutManager(this));

        rv.addItemDecoration(new DividerItemDecoration(this, LinearLayoutManager.VERTICAL));
        rv.setItemAnimator(new DefaultItemAnimator());
        mAdapterCouponTypeShopFollow = new CouponTypeShopFollowRecyclerViewAdapter(this, mLstCouponTypeShopFollow);
        rv.setAdapter(mAdapterCouponTypeShopFollow);
    }

    @Override
    public void onLoadData() {
        mLstCouponTypeShopFollow = new ArrayList<>();

        new CouponAPIHelper().getCatShopFollow(mContext, "1", mHanlderGetCouponTypeShopFollow);

    }
    protected Handler mHanlderGetCouponTypeShopFollow = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case APIConstants.HANDLER_REQUEST_SERVER_SUCCESS:
                    ResponseCategoryShopFollowData couponTypeShopFollow = (ResponseCategoryShopFollowData) msg.obj;
                    if (couponTypeShopFollow.code == APIConstants.REQUEST_OK && couponTypeShopFollow.httpCode == APIConstants.HTTP_OK) {
                        mAdapterCouponTypeShopFollow.updateData(couponTypeShopFollow.data);
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
