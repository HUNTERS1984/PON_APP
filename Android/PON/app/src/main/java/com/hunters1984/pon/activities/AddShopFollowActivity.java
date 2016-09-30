package com.hunters1984.pon.activities;

import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v7.widget.DefaultItemAnimator;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;

import com.hunters1984.pon.R;
import com.hunters1984.pon.adapters.DividerItemDecoration;
import com.hunters1984.pon.adapters.ListCouponTypeShopFollowRecyclerViewAdapter;
import com.hunters1984.pon.api.APIConstants;
import com.hunters1984.pon.api.CouponAPIHelper;
import com.hunters1984.pon.api.ResponseCouponTypeShopFollowData;
import com.hunters1984.pon.models.CouponTypeShopFollowModel;
import com.hunters1984.pon.protocols.OnLoadDataListener;
import com.hunters1984.pon.utils.DialogUtiils;

import java.util.ArrayList;
import java.util.List;

public class AddShopFollowActivity extends BaseActivity implements OnLoadDataListener {

    private List<CouponTypeShopFollowModel> mLstCouponTypeShopFollow;
    private ListCouponTypeShopFollowRecyclerViewAdapter mAdapterCouponTypeShopFollow;

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
        mAdapterCouponTypeShopFollow = new ListCouponTypeShopFollowRecyclerViewAdapter(this, mLstCouponTypeShopFollow);
        rv.setAdapter(mAdapterCouponTypeShopFollow);
    }

    @Override
    public void onLoadData() {
        mLstCouponTypeShopFollow = new ArrayList<>();

        new CouponAPIHelper().getCouponTypeShopFollow(mContext, "1", mHanlderGetCouponTypeShopFollow);

//        for(int i=0; i<5; i++){
//            ShopModel shop = new ShopModel();
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
//
//            shop.setmNumberOfShopSubscribe(String.valueOf(100*i+1));
//            mListShops.add(shop);
//        }
    }
    protected Handler mHanlderGetCouponTypeShopFollow = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            ResponseCouponTypeShopFollowData couponTypeShopFollow = (ResponseCouponTypeShopFollowData) msg.obj;
            if (couponTypeShopFollow.code == APIConstants.REQUEST_OK){
                mAdapterCouponTypeShopFollow.updateData(couponTypeShopFollow.data);
            } else {
                new DialogUtiils().showDialog(mContext, getString(R.string.connection_failed), false);
            }
        }
    };
}
