package com.hunters1984.pon.activities;

import android.app.Activity;
import android.os.Bundle;
import android.support.v7.widget.DefaultItemAnimator;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;

import com.hunters1984.pon.R;
import com.hunters1984.pon.adapters.DividerItemDecoration;
import com.hunters1984.pon.adapters.ListShopRecyclerViewAdapter;
import com.hunters1984.pon.models.ShopModel;
import com.hunters1984.pon.protocols.OnLoadDataListener;

import java.util.ArrayList;
import java.util.List;

public class ShopSubscribeActivity extends BaseActivity implements OnLoadDataListener {


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        setContentView(R.layout.activity_shop_subscribe);
        mContext = this;
        mDataListener = this;
        super.onCreate(savedInstanceState);

        initLayout();

    }

    private void initLayout()
    {
        RecyclerView rv = (RecyclerView)findViewById(R.id.rv_shop_subscribe);
        rv.setLayoutManager(new LinearLayoutManager(this));

        rv.addItemDecoration(new DividerItemDecoration(this, LinearLayoutManager.VERTICAL));
        rv.setItemAnimator(new DefaultItemAnimator());
        ListShopRecyclerViewAdapter adapter = new ListShopRecyclerViewAdapter(this, mListShops, false);
        rv.setAdapter(adapter);
    }

    @Override
    public void onLoadData() {
        mListShops = new ArrayList<>();

        for(int i=0; i<5; i++){
            ShopModel shop = new ShopModel();
            shop.setmShopName("Shop B");
            shop.setmNumberOfShopSubscribe(String.valueOf(100*i+1));
            mListShops.add(shop);
        }
    }
}
