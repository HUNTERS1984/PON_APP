package com.hunters1984.pon.activities;

import android.os.Bundle;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;

import com.hunters1984.pon.R;
import com.hunters1984.pon.adapters.CouponRecyclerViewAdapter;
import com.hunters1984.pon.models.CouponModel;
import com.hunters1984.pon.protocols.OnLoadDataListener;

import java.util.ArrayList;

public class HistoryActivity extends BaseActivity implements OnLoadDataListener {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        mDataListener = this;
        setContentView(R.layout.activity_history);
        super.onCreate(savedInstanceState);
        setTitle(getResources().getString(R.string.history));

        RecyclerView rv = (RecyclerView)findViewById(R.id.recycler_view_history);
        rv.setLayoutManager(new GridLayoutManager(this, 2));

        CouponRecyclerViewAdapter adapter = new CouponRecyclerViewAdapter(this, mListCoupons);
        rv.setAdapter(adapter);
    }

    @Override
    public void onLoadData() {
        mListCoupons = new ArrayList<>();
        for(int i=0; i<5; i++) {
            CouponModel coupon = new CouponModel();
            coupon.setmTitle("タイトルが入ります");
            coupon.setmExpireDate("2016-09-27T15:37:46+0000");
            coupon.setmIsFavourite((i%2==0?1:0));
            coupon.setmIsLoginRequired((i%2==0?1:0));
            mListCoupons.add(coupon);
        }
    }
}
