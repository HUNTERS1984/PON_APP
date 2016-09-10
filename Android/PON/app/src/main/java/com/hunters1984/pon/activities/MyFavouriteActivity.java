package com.hunters1984.pon.activities;

import android.os.Bundle;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;

import com.hunters1984.pon.R;
import com.hunters1984.pon.adapters.CouponRecyclerViewAdapter;
import com.hunters1984.pon.models.CouponModel;
import com.hunters1984.pon.protocols.OnLoadDataListener;

import java.util.ArrayList;

public class MyFavouriteActivity extends BaseActivity implements OnLoadDataListener{

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
        for(int i=0; i<5; i++) {
            CouponModel coupon = new CouponModel();
            coupon.setmTitle("Title");
            coupon.setmDescription("Description");
            coupon.setmExpireDate("Expire : 2016.2.7");
            coupon.setmIsFavourite((i%2==0?true:false));
            coupon.setmIsLoginRequired((i%2==0?true:false));
            mListCoupons.add(coupon);
        }
    }

    private void initLayout()
    {
        activeMyFavourite();

        RecyclerView rv = (RecyclerView)findViewById(R.id.recycler_view_my_favourite);
        rv.setLayoutManager(new GridLayoutManager(this, 2));

        CouponRecyclerViewAdapter adapter = new CouponRecyclerViewAdapter(this, mListCoupons);
        rv.setAdapter(adapter);
    }
}
