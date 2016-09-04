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

import java.util.ArrayList;
import java.util.List;

public class ShopLocationActivity extends Activity {

    private List<ShopModel> mListShops;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_shop_location);

        initData();

        RecyclerView rv = (RecyclerView)findViewById(R.id.rv_shop);
        rv.setLayoutManager(new LinearLayoutManager(this));

        rv.addItemDecoration(new DividerItemDecoration(this, LinearLayoutManager.VERTICAL));
        rv.setItemAnimator(new DefaultItemAnimator());
        ListShopRecyclerViewAdapter adapter = new ListShopRecyclerViewAdapter(this, mListShops, true);
        rv.setAdapter(adapter);

    }

    private void initData()
    {
        mListShops = new ArrayList<>();

        for(int i=0; i<5; i++){
            ShopModel shop = new ShopModel();
            shop.setmShopName("Shop B");
            mListShops.add(shop);
        }
    }
}
